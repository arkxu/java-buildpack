# Copyright (C) 1999-2013, Intalio Inc.
#
# The program(s) herein may be used and/or copied only with
# the written permission of Intalio Inc. or in accordance with
# the terms and conditions stipulated in the agreement/contract
# under which the program(s) have been supplied.

require 'spec_helper'
require 'java_buildpack/buildpack'

describe JavaBuildpack do

  it 'should return true if it can handle' do
    handle = JavaBuildpack::Buildpack.new('spec/fixtures/valid_app').detect
    expect(handle).to be_true
  end

  it 'should return false if it is not intalio create app' do
    handle = JavaBuildpack::Buildpack.new('spec/fixtures/invalid_app').detect
    expect(handle).to be_false
  end

  it 'should return true as there is intalio manifest.yml' do
    handle = JavaBuildpack::Buildpack.new('spec/fixtures/valid_app_manifest').detect
    expect(handle).to be_true
  end
end
