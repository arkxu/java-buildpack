# Copyright (C) 1999-2013, Intalio Inc.
#
# The program(s) herein may be used and/or copied only with
# the written permission of Intalio Inc. or in accordance with
# the terms and conditions stipulated in the agreement/contract
# under which the program(s) have been supplied.

require 'spec_helper'
require 'neocore_buildpack/utils/manifest_reader'

describe NeocoreBuildpack::ManifestReader do

  it 'should read the attributes in manifest.yml' do
    reader = NeocoreBuildpack::ManifestReader.new('spec/fixtures/valid_app_manifest')

    reader.application_name.should == 'intalio'
    reader.war_file_url.should match(/downloads.intalio.com/)
    reader.data_package_url.should match(/downloads.intalio.com/)
  end

end
