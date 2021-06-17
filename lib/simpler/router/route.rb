module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        route_path = split_path(@path)
        req_path   = split_path(path)

        return false if @method != method || route_path.size != req_path.size

        route_path.each_with_index do |part, index|
          if part != req_path[index]
            if part.start_with? ':' 
              @params[part[1..-1]] = req_path[index]
            else
              return false
            end
          end
        end

        true
      end

      private

      def split_path(path)
        path[1..-1].split('/')
      end

    end
  end
end
