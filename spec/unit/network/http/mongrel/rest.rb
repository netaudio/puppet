#!/usr/bin/env ruby
#
#  Created by Rick Bradley on 2007-10-16.
#  Copyright (c) 2007. All rights reserved.

require File.dirname(__FILE__) + '/../../../../spec_helper'
require 'puppet/network/http'

describe Puppet::Network::HTTP::MongrelREST, "when initializing" do
    before do
        @mock_mongrel = mock('Mongrel server')
        @mock_mongrel.stubs(:register)
        @mock_model = mock('indirected model')
        Puppet::Indirector::Indirection.stubs(:model).with(:foo).returns(@mock_model)
        @params = { :server => @mock_mongrel, :handler => :foo }
    end
    
    it "should require access to a Mongrel server" do
        Proc.new { Puppet::Network::HTTP::MongrelREST.new(@params.delete_if {|k,v| :server == k })}.should raise_error(ArgumentError)
    end
    
    it "should require an indirection name" do
        Proc.new { Puppet::Network::HTTP::MongrelREST.new(@params.delete_if {|k,v| :handler == k })}.should raise_error(ArgumentError)        
    end
    
    it "should look up the indirection model from the indirection name" do
        Puppet::Indirector::Indirection.expects(:model).with(:foo).returns(@mock_model)
        Puppet::Network::HTTP::MongrelREST.new(@params)
    end
    
    it "should fail if the indirection is not known" do
        Puppet::Indirector::Indirection.expects(:model).with(:foo).returns(nil)
        Proc.new { Puppet::Network::HTTP::MongrelREST.new(@params) }.should raise_error(ArgumentError)
    end

    it "should register itself with the mongrel server for the singular HTTP methods" do
        @mock_mongrel.expects(:register).with do |*args|
            args.first == '/foo' and args.last.is_a? Puppet::Network::HTTP::MongrelREST
        end
        Puppet::Network::HTTP::MongrelREST.new(@params)
    end

    it "should register itself with the mongrel server for the plural GET method" do
        @mock_mongrel.expects(:register).with do |*args|
            args.first == '/foos' and args.last.is_a? Puppet::Network::HTTP::MongrelREST
        end
        Puppet::Network::HTTP::MongrelREST.new(@params)
    end
end

describe Puppet::Network::HTTP::MongrelREST, "when receiving a request" do
    it "should unpack request information from Mongrel"
    it "should unpack parameters from the request for passing to controller methods"    
    it "should call the controller find method if the request represents a singular HTTP GET"
    it "should call the controller search method if the request represents a plural HTTP GET"
    it "should call the controller destroy method if the request represents an HTTP DELETE"
    it "should call the controller save method if the request represents an HTTP PUT"
    it "should serialize the result from the controller method for return back to Mongrel"
    it "should serialize a controller expection result for return back to Mongrel"
end
