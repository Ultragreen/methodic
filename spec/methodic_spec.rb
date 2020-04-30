require'rubygems'
require'rspec'
require 'methodic'

describe Methodic do

  before :all do
    $test_methodic_options = Methodic::get_options :name => 'Doe', :surname => 'John'
    $test_methodic_options_with_known_options = Methodic::get_options({:name => 'Doe', :surname => 'John'},true)
  end
  before :each do
    $test_methodic_options.mandatories.clear
    $test_methodic_options.formats = {}
    $test_methodic_options.defaults = {}
    $test_methodic_options.classes = {}
  end
  subject { Methodic }
  specify { expect(subject).to be_an_instance_of Module}
  context Methodic::Options do
    subject { Methodic::Options }
    specify { expect(subject).to be_an_instance_of Class }
    it "should respond to all methods of a Hash" do
      Hash::new.methods.each do |method|
        expect($test_methodic_options).to respond_to(method)
      end
    end
    context "#new(_options) (initialization)" do
      context "Exception case" do
         it "should raise ArgumentError if _options is not a Hash" do
           [ 'a string', 12 ,Array::new,true,false].each do |item|
             expect { Methodic::Options::new(item) }.to raise_error(ArgumentError)

           end
         end
        it "should raise ArgumentError if an Hash arg is passed to initializer but with keys different of Symbol" do
          expect { Methodic::Options::new({'titi' => 'tutu'}) }.to raise_error(ArgumentError)
        end
        it "should raise ArgumentError if more than two arg is passed to initializer" do
          expect { Methodic::Options::new({:name => 'Doe'},{:surname => 'John'},true) }.to raise_error(ArgumentError)
        end

      end

    end
    context "Instance Attributs" do
      context "#classes R/W" do
        specify { expect($test_methodic_options).to respond_to("classes") }
        specify { expect($test_methodic_options).to respond_to("classes=") }

        it "should be true that #classes must return a Hash" do
          expect($test_methodic_options.classes.class).to eq(Hash)
        end
        it "#classes[] affectation must be possible and #classes must respond this affectation" do
          $test_methodic_options.classes[:test] = String
          expect($test_methodic_options.classes).to eq({:test => String})
        end

      end
      context "#defaults R/W" do

        specify { expect($test_methodic_options).to respond_to("defaults") }
        specify { expect($test_methodic_options).to respond_to("defaults=") }

        specify { expect($test_methodic_options).to respond_to("toto") }
        specify { expect($test_methodic_options).to respond_to("toto=") }

        it "should be true that #defaults must return a Hash" do
          expect($test_methodic_options.defaults.class).to eq(Hash)
        end
        it "#defaults[] affectation must be possible and #defaults must respond this affectation" do
          $test_methodic_options.defaults[:test] = "value"
          expect($test_methodic_options.defaults).to eq({ :test => "value"})
        end
      end

      context "#formats R/W" do

        specify { expect($test_methodic_options).to respond_to("formats") }
        specify { expect($test_methodic_options).to respond_to("formats=") }


        it "should be true that #formats must return a Hash" do
            expect($test_methodic_options.formats.class).to eq(Hash)
        end
        it "#formats[] affectation must be possible and #formats must respond this affectation" do
          $test_methodic_options.formats[:test] = '.*'
          expect($test_methodic_options.formats).to eq({ :test => '.*' })
        end
      end

      context "#conditions R/W" do

        specify { expect($test_methodic_options).to respond_to("conditions") }
        specify { expect($test_methodic_options).to respond_to("conditions=") }


        it "should be true that #conditions must return a Hash" do
            expect($test_methodic_options.conditions.class).to eq(Hash)
        end

        it "#formats[] affectation must be possible and #formats must respond this affectation" do
          aCond = Proc::new do |option| case option
                                         when 'Doe' then true
                                         else false
                                       end
          end
          $test_methodic_options.conditions[:name] = aCond
          expect($test_methodic_options.conditions).to eq({ :name => aCond })
        end
      end

      context "#mandatories R/W" do
        specify { expect($test_methodic_options).to respond_to("mandatories") }
        specify { expect($test_methodic_options).to respond_to("mandatories=") }

        it "should be true that #mandatories must return a List < Array" do
            expect($test_methodic_options.mandatories.class).to eq(List)
        end
        it "#mandatories.push affectation must be possible and #mandatories must respond this affectation" do
          $test_methodic_options.mandatories.push :test
          expect($test_methodic_options.mandatories).to eq([:test])
        end
        context "#mandatories.push" do
          it "should not duplicate entry"do
            $test_methodic_options.mandatories.push :test
            $test_methodic_options.mandatories.push :test
            expect($test_methodic_options.mandatories.count(:test)).to eq 1
          end
        end
      end


      context "#known R/W" do
        specify { expect($test_methodic_options).to respond_to("known") }
        specify { expect($test_methodic_options).to respond_to("known=") }

        it "should be true that #known must return a List < Array" do
            expect($test_methodic_options.known.class).to eq(List)
        end
        it "#known.push affectation must be possible and #known must respond this affectation" do
          $test_methodic_options.known.push :test
          expect($test_methodic_options.known).to include :test
        end
        context "#known.push" do
          it "should not duplicate entry" do
            $test_methodic_options.known.push :test
            $test_methodic_options.known.push :test
            expect($test_methodic_options.known.count(:test)).to eq 1
          end
        end
      end
    end
    context "Instance methods" do




      context "#options" do
        specify { expect($test_methodic_options).to respond_to("options") }
        it "should be true that #options must return a Array" do
          expect($test_methodic_options.options.class).to eq(Array)
        end
        it "should respond an Array of options keys" do
          $test_methodic_options.options.each do |item|
            expect([:name,:surname]).to include item
          end
        end
      end

      context "#specify_default_value" do
        specify { expect($test_methodic_options).to respond_to("specify_default_value") }
        specify { expect($test_methodic_options).to respond_to("specify_defaults_values") }

        it "should merge default value hash record in defaults attribut" do

          $test_methodic_options.specify_default_value :test => 'value'
          expect($test_methodic_options.defaults[:test]).to eq 'value'
          expect($test_methodic_options.defaults.count).to eq 1
        end
        it "should redefine a new default value for a previous key" do
          $test_methodic_options.specify_default_value :test => 'value'
          expect($test_methodic_options.defaults[:test]).to eq 'value'
          $test_methodic_options.specify_default_value :test => 'newvalue'
          expect($test_methodic_options.defaults[:test]).to eq 'newvalue'
        end
      end

      context "#specify_class_of" do
        specify { expect($test_methodic_options).to respond_to("specify_class_of") }
        specify { expect($test_methodic_options).to respond_to("specify_classes_of") }

        it "should merge class hash record in classes attribut" do

          $test_methodic_options.specify_class_of :test => String
          expect($test_methodic_options.classes[:test]).to eq String
          expect($test_methodic_options.classes.count).to eq 1
        end
        it "should redefine a new class value for a previous key" do
          $test_methodic_options.specify_class_of :test => String
          expect($test_methodic_options.classes[:test]).to eq String
          $test_methodic_options.specify_class_of :test => Integer
          expect($test_methodic_options.classes[:test]).to eq Integer

        end
      end





      context "#specify_condition_for" do
        specify { expect($test_methodic_options).to respond_to("specify_condition_for") }
        specify { expect($test_methodic_options).to respond_to("specify_conditions_for") }

        it "should merge condition hash record in conditions attribut" do
          aCond = Proc::new do |option| case option
                                         when "Doe" then true
                                         else false
                                       end
          end
          $test_methodic_options.specify_condition_for :name => aCond
          expect($test_methodic_options.conditions[:name]).to eq aCond
          expect($test_methodic_options.conditions.count).to eq 1
        end
        it "should redefine a new class value for a previous key" do
          aCond = Proc::new do |option| case option
                                         when "Doe" then true
                                         else false
                                       end
          end
          newCond = Proc::new do |option| case option
                                         when "DoeLittle" then true
                                         else false
                                       end
          end
          $test_methodic_options.specify_condition_for :name => aCond
          expect($test_methodic_options.conditions[:name]).to eq aCond
          $test_methodic_options.specify_condition_for :name => newCond
          expect($test_methodic_options.conditions[:name]).to eq newCond
          $test_methodic_options.conditions = {}
        end
      end

      context "#specify_format_of" do
        specify { expect($test_methodic_options).to respond_to("specify_format_of") }
        specify { expect($test_methodic_options).to respond_to("specify_formats_of") }
        it "should merge format hash record in formats attribut" do
          $test_methodic_options.formats = {}
          $test_methodic_options.specify_format_of :test => '.*'
          expect($test_methodic_options.formats[:test]).to eq '.*'
          expect($test_methodic_options.formats.count).to eq 1
        end
        it "should redefine a new format value for a previous format key" do
          $test_methodic_options.specify_format_of :test => '.*'
          expect($test_methodic_options.formats[:test]).to eq '.*'
          $test_methodic_options.specify_format_of :test => '\d*'
          expect($test_methodic_options.formats[:test]).to eq '\d*'
        end
      end

      context "#specify_presence_of" do
        specify { expect($test_methodic_options).to respond_to("specify_presence_of") }
        specify { expect($test_methodic_options).to respond_to("specify_presences_of") }

        it "should merge presence Array record in mandatories attribut" do
          $test_methodic_options.specify_presence_of :test
          expect($test_methodic_options.mandatories).to include(:test)
          expect($test_methodic_options.mandatories.count).to eq 1
          $test_methodic_options.specify_presence_of :test
          expect($test_methodic_options.mandatories).to include(:test)
          expect($test_methodic_options.mandatories.count).to eq 1
        end
        it "should be possible to give arguments list of symbols" do
          $test_methodic_options.specify_presences_of :test2, :test3, :test4
          $test_methodic_options.specify_presences_of [ :test5, :test6 ], :test7
        end
      end

      context "#specify_known_option" do
        specify { expect($test_methodic_options).to respond_to("specify_known_option") }
        specify { expect($test_methodic_options).to respond_to("specify_known_options") }

        it "should merge known Array record in known attribut" do
          $test_methodic_options.specify_known_option :test
          expect($test_methodic_options.known).to include(:test)
          expect($test_methodic_options.known.count).to eq 1
          $test_methodic_options.specify_known_option :test
          expect($test_methodic_options.known).to include(:test)
          expect($test_methodic_options.known.count).to eq 1
        end
        it "should be possible to give arguments list of symbols" do
          $test_methodic_options.specify_known_options :test2, :test3, :test4
          $test_methodic_options.specify_known_options [ :test5, :test6 ], :test7

        end
      end

      context "#validate" do

        specify { expect($test_methodic_options).to respond_to("validate") }
        specify { expect($test_methodic_options).to respond_to("validate!") }


        context "1/ validate known options" do
          context "@validate_known_options = true" do
            it "should raise ArgumentError if mandatories is not fully include in the known options list" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_presences_of [ :name, :surname ]
              $test_methodic_options_with_known_options.specify_known_options [ :surname ]
              expect { $test_methodic_options_with_known_options.validate! }.to raise_error(ArgumentError)
            end
            it "should raise ArgumentError if an option in options list not in the known options list" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_known_options [ :surname]
              expect { $test_methodic_options_with_known_options.validate! }.to raise_error(ArgumentError)
            end
            it "should raise ArgumentError if formats made a reference to an unknown options" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_format_of :nickname => /.*/
              $test_methodic_options_with_known_options.specify_known_options [ :surname, :name ]
              expect { $test_methodic_options_with_known_options.validate! }.to raise_error(ArgumentError)
            end
            it "should raise ArgumentError if classes made a reference to an unknown options" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options[:nickname] = 'Jeedoe'
              $test_methodic_options_with_known_options.specify_class_of :nickname => String
              $test_methodic_options_with_known_options.specify_known_options [ :surname, :name ]
              expect { $test_methodic_options_with_known_options.validate! }.to raise_error(ArgumentError)
            end
            it "should raise ArgumentError if default made a reference to an unknown options" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_default_value :nickname => 'Jeedoe'
              $test_methodic_options_with_known_options.specify_known_options [ :surname, :name ]
              expect { $test_methodic_options_with_known_options.validate! }.to raise_error(ArgumentError)
            end

          end

        end

        context "2/ validate classes" do
          it "should raise ArgumentError if an options don't match a class definition" do
            $test_methodic_options.specify_classes_of :name => Integer, :surname => String
            expect { $test_methodic_options.validate! }.to raise_error(ArgumentError)

          end
        end
        context "3/ validate mandatories" do
          it "should raise ArgumentError if a mandatory option not in options list" do
            $test_methodic_options.specify_presences_of [ :name , :surname, :nickname, :age ]
            expect { $test_methodic_options.validate! }.to raise_error(ArgumentError)

          end
        end
        context "4/ validate formats" do
          it "should raise ArgumentError if an option in options list not have the good registered formats" do
            $test_methodic_options.specify_formats_of :name => /.*/, :surname => /toto.*/
            expect { $test_methodic_options.validate! }.to raise_error(ArgumentError)

          end
        end
        context "5/ validate conditions" do
          it "should raise ArgumentError if an option in options list not validate a registered condition" do
            $test_methodic_options.conditions = {}
            aCond = Proc::new do |option| case option
                                            when 'DoeLittle' then true
                                            else false
                                          end
            end
            $test_methodic_options.specify_condition_for :name => aCond
            expect { $test_methodic_options.validate! }.to raise_error(ArgumentError)

          end
        end



      end
      context "#merge_with_defaults" do
        specify { expect($test_methodic_options).to respond_to("merge_with_defaults") }
        specify { expect($test_methodic_options).to respond_to("merge") }

        it "should merge defaults values and don't override with options" do
          $test_methodic_options.specify_defaults_values :name => 'Smith', :surname => 'Paul', :nickname => 'Jeedoe'
          $test_methodic_options.merge_with_defaults
          expect($test_methodic_options[:name]).to eq "Doe"
          expect($test_methodic_options[:surname]).to eq "John"
          expect($test_methodic_options[:nickname]).to eq "Jeedoe"

        end
      end
    end
  end
  context "Methodic::get_options" do
    it "should return a Methodic::Options Object" do
      expect(Methodic::get_options({:name => 'Doe', :surname => 'John'})).to be_an_instance_of Methodic::Options
    end
  end

end
