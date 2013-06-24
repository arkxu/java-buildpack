# Copyright (C) 1999-2013, Intalio Inc.
#
# The program(s) herein may be used and/or copied only with
# the written permission of Intalio Inc. or in accordance with
# the terms and conditions stipulated in the agreement/contract
# under which the program(s) have been supplied.

require 'spec_helper'
require 'yaml'

describe NeocoreBuildpack::Release do

  it 'should return the execution command payload' do
    payload = NeocoreBuildpack::Release.new('spec/fixtures/valid_app').run
    expect(payload).to eq({
      'addons' => [],
      'config_vars' => {},
      'default_process_types' => {
        'web' => 'export PATH=../.java/bin:$PATH; eclipse/start.sh -Djetty.port=$PORT'
      }
    }.to_yaml)
  end

end
