# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require File.expand_path('../../../config/environment',  __FILE__)

module GloboDns
module Config

    def self.load(yaml_string)
        template = ERB.new(yaml_string)
        yml = YAML::load(template.result)
        set_constants(yml[Rails.env])
    end

    def self.load_from_file(file = Rails.root.join('config', 'globodns.yml'))
        self.load(IO::read(file))
    end

    protected

    def self.set_constants(hash, module_ = self)
        hash.each do |key, value|
            if value.is_a?(Hash)
                new_module = module_.const_set(key.camelize, Module.new)
                self.set_constants(value, new_module)
            else
                module_.const_set(key.upcase, value)
            end
        end
        true
    end

    def SLAVE_ENABLED?
        !BIND_SLAVE_HOST.nil? and BIND_SLAVE_HOST != ''
    end

end # Config
end # GloboDns
