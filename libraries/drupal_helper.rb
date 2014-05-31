#
# Cookbook Name:: drupalbaseplus
# Library:: drupal_helper
#
# Copyright 2014, OpenSinergia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#chef_gem 'json'
require 'json'
#chef_gem 'deep_merge'
require 'deep_merge'

module Drupal
  module Helper

    def build_items(current_element, ancestor, answer)
      # for hashes, like the "projects" and "libraries" cases
      current_element.class == Hash && current_element.each {|k, v|
        if v.class == Hash && v.empty?
          answer << ancestor + "[] = " + k
        elsif v.class == String
          answer << ancestor + "[" + k + "] = " + v
        elsif v.class == Hash && !v.empty?
          #build_items(build_items[k], ancestor + "[" + k + "]", answer) # equivalent
          build_items(v, ancestor + "[" + k + "]", answer)
        end
      } 
      # for plain strings, like the "translations" case
      answer << ancestor + "[] = " + current_element if current_element.class == String
    end

    # generates the projects, libraries and translations elements of a drusk make file
    # hash param is the data structure containing all the elements needed (deep structure)
    def generate_plt(final_hash)
      answer = Array.new
      ["projects", "libraries", "translations"].each do |top_item|
        final_hash[top_item] && build_items(final_hash[top_item], top_item, answer)
      end
      answer
    end

    # merge two strings containing json formatted data of projects
    # (including themes), libraries and translations
    def merge_json_to_hash(array_of_jsons)
      merged_hash = {} # merged_hash its the "parent" element
      # type of array_of_jsons is Chef::Node::ImmutableArray
      if array_of_jsons.is_a?(Array) && array_of_jsons.size > 0
        return JSON.parse(array_of_jsons.first) if array_of_jsons.size == 1
        merged_hash = JSON.parse(array_of_jsons.first)
        # potentially an arbitrary number of childs could be used
        # but normally one child and one parent will be present
        array_of_jsons[1 .. array_of_jsons.size].each { |it|
          next_child = JSON.parse(it)
          merged_hash = next_child.deep_merge(merged_hash)
        }
      end
      # possibly, the child may exclude some project or library
      # included by the parent
      # TODO: how could the child exclude all kinds of parent's translations ?
      ["projects", "libraries"].each do |it|
        merged_hash[it].delete_if { |k,v|
          v.class == Hash && v.has_key?("enabled") && v['enabled'] == "false"
        }
      end
      return merged_hash
    end
 end
end
