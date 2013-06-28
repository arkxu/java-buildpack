# Copyright (C) 1999-2013, Intalio Inc.
#
# The program(s) herein may be used and/or copied only with
# the written permission of Intalio Inc. or in accordance with
# the terms and conditions stipulated in the agreement/contract
# under which the program(s) have been supplied.

require 'uri'
require 'java_buildpack/container'
require 'java_buildpack/repository/configured_item'
require 'java_buildpack/util/application_cache'
require 'java_buildpack/util/format_duration'

module NeocoreBuildpack::Container

  # Encapsulates the detect, compile, and release functionality for Tomcat applications.
  class NeocoreJetty

    # Creates an instance, passing in an arbitrary collection of options.
    #
    # @param [Hash] context the context that is provided to the instance
    # @option context [String] :app_dir the directory that the application exists in
    # @option context [String] :java_home the directory that acts as +JAVA_HOME+
    # @option context [Array<String>] :java_opts an array that Java options can be added to
    # @option context [Hash] :configuration the properties provided by the user
    def initialize(context)
      @app_dir = context[:app_dir]
      @java_home = context[:java_home]
      @java_opts = context[:java_opts]
      @configuration = context[:configuration]
      @manifest_reader = NeocoreBuildpack::ManifestReader.new(@app_dir)
    end

    # Detects whether this application is a Tomcat application.
    #
    # @return [String] returns +tomcat-<version>+ if and only if the application has a +WEB-INF+ directory, otherwise
    #                  returns +nil+
    def detect
      true
    end

    # Downlaods and unpacks a Tomcat instance
    #
    # @return [void]
    def compile
      download_intalio_app
      download_data_package
      nil
    end

    # Creates the command to run the Tomcat application.
    #
    # @return [String] the command to run the application.
    def release
      @java_opts << "-Djetty.port=$PORT -Dcom.mchange.v2.log.MLog=com.mchange.v2.log.FallbackMLog -Dcom.mchange.v2.log.FallbackMLog.DEFAULT_CUTOFF_LEVEL=WARNING -Dlogback.root.level=WARN -Dlogback.appender=FILE_CF"

      "JAVA_HOME=#{@java_home} JAVA_OPTS=\"#{java_opts}\" eclipse/start.sh"
    end

    private

    def java_opts
      @java_opts.compact.sort.join(' ')
    end

    def download_intalio_app
      war_file = File.join(@app_dir, NeocoreBuildpack::WAR_FILE_NAME)

      unless File.exists?(war_file)
        war_file_url = @manifest_reader.war_file_url
        puts "-----> Downloading intalio war file from #{war_file_url}"
        system("curl #{war_file_url} -s -o #{war_file}")
      end

      `tar zxf #{@app_dir}/#{NeocoreBuildpack::WAR_FILE_NAME} -C #{@app_dir}`
      File.delete("#{@app_dir}/#{NeocoreBuildpack::WAR_FILE_NAME}")      
    end

    def download_data_package
      data_package_file = File.join(@app_dir, NeocoreBuildpack::DATA_PACKAGE_FILE_NAME)

      unless File.exists?(data_package_file)
        data_package_file_url = @manifest_reader.data_package_url
        puts "-----> Downloading intalio data package file from #{data_package_file_url}"
        system("curl #{data_package_file_url} -s -o #{data_package_file}")        
      end

      puts "-----> Package downloaded. "

      data_package_folder = File.join(@app_dir, NeocoreBuildpack::DATA_PACKAGE_FOLDER)
      `rm -fr #{data_package_folder}`
      `mkdir -p #{data_package_folder}`
      `unzip -o #{data_package_file} -d #{data_package_folder}`
      puts "-----> Package extraced. "
      File.delete("#{data_package_file}")
      puts `ls -l -a #{@app_dir}`      
    end
  end
end
