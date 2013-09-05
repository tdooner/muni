module Muni
  class VehicleLocation < Base
    @@last_request_time = 0

    class << self
      def all(options = {})
        options[:t] ||= 0

        document = send(:fetch, :vehicleLocations, options)

        @@last_request_time = document["lastTime"].first["time"].to_i

        vehicles = document['vehicle'] || []
        vehicles.map do |v|
          VehicleLocation.new(v)
        end
      end

      def since(time, options = {})
        options.merge!(t: time.to_i * 1000)

        all(options)
      end

      def since_last_request(options = {})
        since(Time.at(@@last_request_time / 1000), options)
      end
    end
  end
end
