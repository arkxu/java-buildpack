# Copyright (C) 1999-2013, Intalio Inc.
#
# The program(s) herein may be used and/or copied only with
# the written permission of Intalio Inc. or in accordance with
# the terms and conditions stipulated in the agreement/contract
# under which the program(s) have been supplied.

require 'yaml'

module NeocoreBuildpack
  class ManifestReader
    def initialize(app_dir)
      deploy_file = File.join(app_dir, 'manifest.yml')

      if File.exists?(deploy_file)
        @deploy_manifest = YAML.load(File.new(deploy_file))
      else
        raise "Can not find manifest.yml"
      end
    end


    def application_name
      if @deploy_manifest['applications'] && @deploy_manifest['applications'][0]
        return @deploy_manifest['applications'][0]['name']
      end

      nil
    end

    def war_file_url
      if application_name == 'intalio' && @deploy_manifest['applications'][0]['env']
        return @deploy_manifest['applications'][0]['env']['war_file_url']
      end
      nil
    end

    def data_package_url
      if application_name == 'intalio' && @deploy_manifest['applications'][0]['env']
        return @deploy_manifest['applications'][0]['env']['data_package_url']
      end
      nil
    end
  end
end