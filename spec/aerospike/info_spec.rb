# encoding: utf-8

# Copyright 2014-2018 Aerospike, Inc.
#
# Portions may be licensed to Aerospike, Inc. under one or more contributor
# license agreements.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

require "benchmark"

describe Aerospike::Info do

  describe "#request" do
    let(:conn) { Support.client.nodes.first.get_connection(3) }

    it "should connect and request info from the server" do
      info = Aerospike::Info.request(conn)
      expect(info).to include("version")
    end
  end

end
