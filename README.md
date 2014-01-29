# Carrierwave::Processor

> ATTENTION! Now works only for rails 4-0-stable head branch
> Because of carrierwave does not support 4.2, and 4.1 release does not support 'prepend' that only way to make class_eval proxy work

## Installation
To use with Bundler:

    gem 'carrierwave-processor', '~> 1.0'


To require in non-rails
    
    require 'carrierwave/processor'

## Use

Now you can write groups of Carrierwave processors and versions outside of Uploader


Just use **carrierwave_processor** somewhere for processor declaration
    
    carrierwave_processor :image do
      process :fix_exif_rotation
      process :convert => 'jpg'
      version :square do
        process :scale => [100, 100]
      end

      version :default do
        process :scale => [500, 500]
      end

      version :small do
        process :scale_to_fit => [100, 100]
      end
      
      def fix_exif_rotation
        manipulate! do |img|
          img.tap(&:auto_orient)
        end
      end
    end


and use_processor in Uploader

    class SomeUploader < CarrierWave::Uploader::Base
      use_processor :image, :if => :image?

      def image? m
       # ...
      end
    end
