# Copyright (C) 1999-2013, Intalio Inc.
#
# The program(s) herein may be used and/or copied only with
# the written permission of Intalio Inc. or in accordance with
# the terms and conditions stipulated in the agreement/contract
# under which the program(s) have been supplied.

require 'spec_helper'
require 'java_buildpack/buildpack'
require 'tmpdir'

describe JavaBuildpack do
  before do

    stub_request(:get, "http://download.pivotal.io.s3.amazonaws.com/openjdk/lucid/x86_64/index.yml").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})    
  end

  it 'should download jre from uri and extract intalio webapp' do

    Dir.mktmpdir do |root|
      FileUtils.cp_r "spec/fixtures/valid_app/.", root

      JavaBuildpack::Buildpack.new(root).compile

      java = File.join(root, '.java', 'bin', 'java')
      expect(File.exists?(java)).to be_true

      intalio_app = File.join(root, 'eclipse')
      expect(File.exist?(intalio_app)).to be_true

      data_package = File.join(root, JavaBuildpack::DATA_PACKAGE_FOLDER)
      expect(File.exist?(data_package)).to be_true

      bootstrap_sql = File.join(root, JavaBuildpack::DATA_PACKAGE_FOLDER, "bootstrap.sql")
      expect(File.exist?(bootstrap_sql)).to be_true
    end    
  end

  it 'should download war file and package file' do
    Dir.mktmpdir do |root|
      FileUtils.cp_r "spec/fixtures/valid_app_manifest/.", root

      JavaBuildpack::Buildpack.new(root).compile

      java = File.join(root, '.java', 'bin', 'java')
      expect(File.exists?(java)).to be_true

      intalio_app = File.join(root, 'eclipse')
      expect(File.exist?(intalio_app)).to be_true

      data_package = File.join(root, JavaBuildpack::DATA_PACKAGE_FOLDER)
      expect(File.exist?(data_package)).to be_true

      bootstrap_sql = File.join(root, JavaBuildpack::DATA_PACKAGE_FOLDER, "bootstrap.sql")
      expect(File.exist?(bootstrap_sql)).to be_true
    end    
  end
end
