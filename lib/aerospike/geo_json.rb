# encoding: utf-8
# Copyright 2015-2017 Aerospike, Inc.
#
# Portions may be licensed to Aerospike, Inc. under one or more contributor
# license agreements.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

require "json"

module Aerospike

  ##
  # Wrapper for GeoJSON data.
  # GeoJSON data needs to be wrapped to allow the client to distinguish
  # geospatial data from string (or hash) data. Geospatial data from a record's
  # bin will be returned as an instance of this class.
  # The wrapper accepts GeoJSON data either as a String or a Hash.

  class GeoJSON

    def initialize(data)
      self.json_data =
        case data
        when String
          data
        else
          data.to_json
        end
    end

    def to_json
      json_data
    end
    alias_method :to_s, :to_json

    def to_hash
      JSON.parse(json_data)
    end
    alias_method :to_h, :to_hash

    def ==(other)
      return false unless other.class == self.class
      other.to_json == self.to_json
    end

    def lng
      case type
      when 'Point'
        coordinates.first
      when 'AeroCircle'
        coordinates.first.first
      end
    end

    def lat
      case type
      when 'Point'
        coordinates.last
      when 'AeroCircle'
        coordinates.first.last
      end
    end

    def radius
      return nil unless circle?

      coordinates.last
    end

    def coordinates
      to_h['coordinates']
    end

    def type
      to_h['type']
    end

    def point?
      type == 'Point'
    end

    def circle?
      type == 'AeroCircle'
    end

    def polygon?
      type == 'Polygon'
    end

    def self.point(lng, lat)
      new(type: 'Point', coordinates: [lng, lat])
    end

    def self.circle(lng, lat, radius)
      new(type: 'AeroCircle', coordinates: [[lng, lat], radius])
    end

    def self.polygon(coordinates)
      new(type: 'Polygon', coordinates: coordinates)
    end

    def to_circle(radius)
      raise TypeError, 'Cannot create a Circle from a Polygon' if polygon?

      self.class.circle(lng, lat, radius)
    end

    def to_point
      return self if point?
      raise TypeError, 'Cannot create a Point from a Polygon' if polygon?

      self.class.point(lng, lat)
    end

    protected

    attr_accessor :json_data

  end # class

end # module
