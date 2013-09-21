#!/usr/bin/env ruby

require 'sinatra'
require 'arduino_firmata'
require 'xively-rb'

require 'config'


def adc_to_temp(adc_val)
  emp = Math.log(((10240000/adc_val) - 10000))
  emp = 1 / (0.001129148 + (0.000234125 + (0.0000000876741 * emp * emp ))* emp )
  emp - 273.15 + CORRECTION
end

# setup arduino
configure do
  if $arduino.nil?
    $arduino = ArduinoFirmata.connect SERIAL_DEVICE, :nonblock_io => true
  end

  # set up the xively log thread
  # evil code, yes, but fuck it.
  Thread.new do
    while true
      analog_value = $arduino.analog_read 0
      $current_temperature = adc_to_temp(analog_value)
      sleep 10
    end
  end



end
