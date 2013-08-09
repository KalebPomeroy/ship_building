require 'rubygems'
require 'active_support/core_ext/hash/indifferent_access'
require "yaml"
require 'RMagick'

#
# Pass an image name and a list of attributes. An attribute has [:text, :x, :y] and
# optionally can have [:font_size, :container_height, :container_width, :centered,
# :color ]. It creates a jpeg image in ./images/#{image_name}.jpg
#
def make_card(image_name, things_to_put_on_it)

    card = Magick::ImageList.new
    card.new_image(300, 400)

    puts "Doing #{image_name}..."
    things_to_put_on_it.each do | thing |
        text = Magick::Draw.new
        text_x = (thing[:x] || 0)
        text_y = (thing[:y] || 0)
        rotation = (thing[:rotation] || 0)
        game_text =  (thing[:text])
        game_text = game_text.to_s
        game_text = " " if game_text == ""

        color = (thing[:color] || "black")
        container_width = (thing[:container_width] || 0)
        container_height = (thing[:container_height] || 0)

        text.pointsize = (thing[:font_size] || 14)
        text.gravity = Magick::CenterGravity if thing[:centered]

        text.annotate(card, container_width, container_height, text_x, text_y, game_text) {
            self.fill = color
            self.rotation = rotation
        }


    end

    card.write("images/#{image_name}.jpg")
end

def wordwrap(txt, col=30)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n") if txt
end


YAML::load(File.open('data/enemies.yaml')).with_indifferent_access[:enemies ].each do | card |
    things_to_add = [
            { :text => card[:name], :x => 70, :y => 25, :font_size => 20 },
            { :text => "Enemy - Alien", :x => 80, :y => 200, :font_size => 20 },
            { :text => card[:points], :x => 25, :y => 225, :font_size => 40 , :color=>"green"},
            { :text => "(points)", :x => 25, :y => 240, :font_size => 12 , :color=>"green"},
            { :text => card[:attack], :x => 25, :y => 275, :font_size => 40, :color=>"red" },
            { :text => "(attack)", :x => 25, :y => 290, :font_size => 12 , :color=>"red"},
            { :text => wordwrap(card[:text]), :container_width => 360, :container_height => 20, :y => 240, :centered =>true  },
        ]
    make_card(card[:name], things_to_add)
end

YAML::load(File.open('data/hardware.yaml')).with_indifferent_access[:hardware ].each do | card |
    things_to_add = [
            { :text => card[:name], :x => 70, :y => 25, :font_size => 20 },
            { :text => "#{card[:type]} - #{card[:subtype]}", :x => 80, :y => 200, :font_size => 20 },
            { :text => card[:credits], :x => 25, :y => 225, :font_size => 40 , :color=>"orange"},
            { :text => "(credits)", :x => 25, :y => 240, :font_size => 12 , :color=>"orange"},

            { :text => card[:cost], :x => 225, :y => 370, :font_size => 20 , :color=>"orange"},
            { :text => "Purchase cost:", :x => 125, :y => 370, :font_size => 12 },

            { :text => card[:attack], :x => 25, :y => 275, :font_size => 40, :color=>"red" },
            { :text => "(attack)", :x => 25, :y => 290, :font_size => 12 , :color=>"red"},
            { :text => wordwrap(card[:text]), :container_width => 360, :container_height => 20, :y => 240, :centered =>true  },
        ]
    make_card(card[:name], things_to_add)
end

YAML::load(File.open('data/resources.yaml')).with_indifferent_access[:resources].each do | card |
    things_to_add = [
            { :text => card[:name], :x => 70, :y => 25, :font_size => 20 },
            { :text => "#{card[:type]} - #{card[:subtype]}", :x => 80, :y => 200, :font_size => 20 },
            { :text => card[:credits], :x => 25, :y => 225, :font_size => 40 , :color=>"orange"},
            { :text => "(credits)", :x => 25, :y => 240, :font_size => 12 , :color=>"orange"},

            { :text => card[:cost], :x => 225, :y => 370, :font_size => 20 , :color=>"orange"},
            { :text => "Purchase cost:", :x => 125, :y => 370, :font_size => 12 },

            { :text => card[:attack], :x => 25, :y => 275, :font_size => 40, :color=>"red" },
            { :text => "(attack)", :x => 25, :y => 290, :font_size => 12 , :color=>"red"},
            { :text => wordwrap(card[:text]), :container_width => 360, :container_height => 20, :y => 240, :centered =>true  },
        ]
    make_card(card[:name], things_to_add)
end
YAML::load(File.open('data/technology.yaml')).with_indifferent_access[:technology].each do | card |
    things_to_add = [
            { :text => card[:name], :x => 70, :y => 25, :font_size => 20 },
            { :text => "#{card[:type]} - #{card[:subtype]}", :x => 80, :y => 200, :font_size => 20 },
            { :text => card[:cost], :x => 225, :y => 370, :font_size => 20 , :color=>"orange"},
            { :text => "Purchase cost:", :x => 125, :y => 370, :font_size => 12 },
        ]
    make_card(card[:name], things_to_add)
end
YAML::load(File.open('data/ships.yaml')).with_indifferent_access[:ships].each do | card |
    things_to_add = [
            { :text => card[:name], :x => 70, :y => 25, :font_size => 20 },
        ]

    card[:slots].each_with_index do |  slot, idx |
        things_to_add << { :text => "- #{slot}", :x => 70, :y => (225 + (30*idx)), :font_size => 20 }
    end
    make_card(card[:name], things_to_add)
end
