# Windward

[![Build Status](https://travis-ci.org/yannvery/windward.svg?branch=master)](https://travis-ci.org/yannvery/windward)
[![Coverage Status](https://coveralls.io/repos/yannvery/windward/badge.svg)](https://coveralls.io/r/yannvery/windward)
[![Gem Version](https://badge.fury.io/rb/windward.svg)](http://badge.fury.io/rb/windward)


Windward is a parser for http://meteofrance.com/accueil

## Installation

Add this line to your application's Gemfile:

    gem 'windward'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install windward

## Usage

### Instantiate a Weather object
When a Weather object is instantiate, a request is sent to meteofrance.com and weather informations are stored.

	require 'windward'
	weather = Windward::Weather.new

### Reload Weather informations

    weather.reload

### List availables regions

	weather.regions

### Get actual weather for a specific region

	weather.previsions("Alsace")
	=> {"Rhin (Bas)"=>{"temps"=>"Pluies éparses", "temper"=>"5"}}

This method returns a Hash with weather informations for each department of specified region.
Some regions have 3 departments like "Provence-Alpes-Côte d'Azur".

###

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
