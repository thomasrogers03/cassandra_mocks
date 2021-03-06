module Cassandra
  module Mocks
    class Cluster
      extend Forwardable

      def_delegator :@keyspaces, :[], :keyspace

      def initialize
        @keyspaces = Concurrent::Map.new
      end

      def connect_async(keyspace = nil)
        session = Session.new(keyspace, self)
        Cassandra::Future.value(session)
      end

      def close_async
        Cassandra::Future.value(nil)
      end

      def close
        close_async.get
      end

      def connect(keyspace = nil)
        connect_async(keyspace).get
      end

      def add_keyspace(name, ignore_existing)
        if @keyspaces[name]
          return if ignore_existing
          raise Errors::AlreadyExistsError.new('Cannot create already existing keyspace', 'MockStatement', name, nil)
        end
        @keyspaces[name] = Keyspace.new(name)
      end

      def drop_keyspace(name)
        @keyspaces.delete(name)
      end

      def each_keyspace(&block)
        @keyspaces.values.each(&block)
      end

      def hosts
        %w(DummyHost)
      end

      def find_replicas(*_)
        []
      end

    end
  end
end
