require 'rspec'

module Cassandra
  module Mocks
    describe Statement do

      describe 'cql parsing' do
        it 'should save the input query CQL' do
          expect(Statement.new('SELECT * FROM everything', []).cql).to eq('SELECT * FROM everything')
        end

        context 'when the query is an INSERT query' do
          it 'should be parsed as an insert' do
            statement = Statement.new("INSERT INTO table (  pk1, ck1  ) VALUES ('hello', ?)", [55])
            expect(statement.action).to eq(:insert)
          end

          it 'should map the key value pairs into the table from the parsed query' do
            statement = Statement.new("INSERT INTO table ( pk1, ck1 ) values ('hello', 'world')", [])
            expect(statement.args).to eq(keyspace: nil, table: 'table', values: {'pk1' => 'hello', 'ck1' => 'world'})
          end

          context 'with a namespaced table' do
            it 'should use the table within the specified keyspace' do
              statement = Statement.new("INSERT INTO keyspace.table ( pk1, ck1 ) values ('hello', 'world')", [])
              expect(statement.args).to eq(keyspace: 'keyspace', table: 'table', values: {'pk1' => 'hello', 'ck1' => 'world'})
            end
          end

          context 'with different arguments' do
            it 'should map the key value pairs into the table from the parsed query' do
              statement = Statement.new("  insert INTO other_table (category, message) VALUES   ('goodbye', 'cruel world')", [])
              expect(statement.args).to eq(keyspace: nil, table: 'other_table', values: {'category' => 'goodbye', 'message' => 'cruel world'})
            end
          end

          context 'with a parameterized query' do
            it 'should apply query parameters to the parsed query' do
              statement = Statement.new("INSERT INTO table (category, message, sub_message) VALUES ('goodbye', ?, ?)", %w(world cruel))
              expect(statement.args).to eq(keyspace: nil, table: 'table', values: {'category' => 'goodbye', 'message' => 'world', 'sub_message' => 'cruel'})
            end
          end
        end

        context 'when the query is a SELECT query' do
          it 'should be parsed as an select' do
            statement = Statement.new('SELECT * FROM everything', [55])
            expect(statement.action).to eq(:select)
          end

          it 'should parse the table and column arguments' do
            statement = Statement.new('SELECT * FROM everything', [])
            expect(statement.args).to eq(keyspace: nil, columns: %w(*), table: 'everything', filter: {})
          end

          context 'with a different table' do
            it 'should parse the table and column arguments' do
              statement = Statement.new('SELECT * FROM my_table', [])
              expect(statement.args).to eq(keyspace: nil, columns: %w(*), table: 'my_table', filter: {})
            end
          end

          context 'with a namespaced table' do
            it 'should parse the table and keyspace' do
              statement = Statement.new('SELECT * FROM lockspace.my_table', [])
              expect(statement.args).to eq(keyspace: 'lockspace', columns: %w(*), table: 'my_table', filter: {})
            end
          end

          context 'with different columns' do
            it 'should parse the table and column arguments' do
              statement = Statement.new('SELECT pk1, ck1, field1 FROM everything', [])
              expect(statement.args).to eq(keyspace: nil, columns: %w(pk1 ck1 field1), table: 'everything', filter: {})
            end
          end

          context 'with a restriction' do
            it 'should parse the restriction as a column filter' do
              statement = Statement.new("SELECT * FROM everything WHERE pk1 = 'books'", [])
              expect(statement.args).to eq(keyspace: nil, columns: %w(*), table: 'everything', filter: {'pk1' => 'books'})
            end

            it 'should support multiple restrictions' do
              statement = Statement.new("SELECT * FROM everything WHERE pk1 = 'cds' and ck1 = 'Rock'", [])
              expect(statement.args).to eq(keyspace: nil, columns: %w(*), table: 'everything', filter: {'pk1' => 'cds', 'ck1' => 'Rock'})
            end
          end
        end

      end

    end
  end
end
