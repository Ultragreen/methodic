require'rubygems'
require'rspec'
require 'lib/methodic'

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
  specify { subject.should be_an_instance_of Module}
  context Methodic::Options do 
    subject { Methodic::Options }
    specify { subject.should be_an_instance_of Class }
    it "should respond to all methods of a Hash" do
      Hash::new.methods.each do |method|
        $test_methodic_options.should respond_to(method)
      end
    end
    context "#new(_options) (initialization)" do
      context "Exception case" do
         it "should raise ArgumentError if _options is not a Hash" do
           [ 'a string', 12 ,Array::new,true,false].each do |item|
             lambda{ Methodic::Options::new(item)}.should raise_error ArgumentError
           end
         end
        it "should not raise ArgumentError if no arg is passed to initializer" do
          lambda{ Methodic::Options::new}.should_not raise_error 
        end
        it "should not raise ArgumentError if an Hash arg is passed to initializer" do
          lambda{ Methodic::Options::new  :name => 'Doe' }.should_not raise_error
        end
        it "should raise ArgumentError if an Hash arg is passed to initializer but with keys different of Symbol" do
          lambda{ Methodic::Options::new 'titi' => 'tutu'}.should raise_error ArgumentError 
        end
        it "should not raise ArgumentError if two arg is passed to initializer, second arg has a boolean value, must be object" do
          lambda{ Methodic::Options::new({:name => 'Doe'},true) }.should_not raise_error ArgumentError
        end

        it "should raise ArgumentError if more than two arg is passed to initializer" do
          lambda{ Methodic::Options::new({:name => 'Doe'},{:surname => 'John'},true) }.should raise_error ArgumentError
        end
        
      end

    end
    context "Instance Attributs" do
      context "#classes R/W" do
        it { $test_methodic_options.should respond_to("classes") }
        it { $test_methodic_options.should respond_to("classes=") }

        it "should be true that #classes must return a Hash" do 
          $test_methodic_options.classes.class.should eq(Hash)
        end
        it "#classes[] affectation must be possible and #classes must respond this affectation" do
          $test_methodic_options.classes[:test] = String
          $test_methodic_options.classes.should eq({:test => String})
        end
        
      end
      context "#defaults R/W" do
        it { $test_methodic_options.should respond_to("defaults") }
        it { $test_methodic_options.should respond_to("defaults=") }
        
        it "should be true that #defaults must return a Hash" do
          $test_methodic_options.defaults.class.should eq(Hash)
        end
        it "#defaults[] affectation must be possible and #defaults must respond this affectation" do
          $test_methodic_options.defaults[:test] = "value"
          $test_methodic_options.defaults.should eq({ :test => "value"})
        end
      end

      context "#formats R/W" do
        it { $test_methodic_options.should respond_to("formats") }
        it { $test_methodic_options.should respond_to("formats=") }
        
        it "should be true that #formats must return a Hash" do
            $test_methodic_options.formats.class.should eq(Hash)
        end
        it "#formats[] affectation must be possible and #formats must respond this affectation" do
          $test_methodic_options.formats[:test] = '.*' 
          $test_methodic_options.formats.should eq({ :test => '.*' })
        end
      end

      context "#conditions R/W" do
        it { $test_methodic_options.should respond_to("conditions") }
        it { $test_methodic_options.should respond_to("conditions=") }
        
        it "should be true that #conditions must return a Hash" do
            $test_methodic_options.conditions.class.should eq(Hash)
        end
        it "#formats[] affectation must be possible and #formats must respond this affectation" do
          aCond = Proc::new do |option| case option
                                         when 'Doe' then true
                                         else false
                                       end
          end
          $test_methodic_options.conditions[:name] = aCond 
          $test_methodic_options.conditions.should eq({ :name => aCond })
        end
      end

      context "#mandatories R/W" do
        it { $test_methodic_options.should respond_to("mandatories") }
        it { $test_methodic_options.should respond_to("mandatories=") }

        it "should be true that #mandatories must return a List < Array" do
            $test_methodic_options.mandatories.class.should eq(List)
        end
        it "#mandatories.push affectation must be possible and #mandatories must respond this affectation" do
          $test_methodic_options.mandatories.push :test
          $test_methodic_options.mandatories.should eq([:test])
        end
        context "#mandatories.push" do
          it "should not duplicate entry"do
            $test_methodic_options.mandatories.push :test
            $test_methodic_options.mandatories.push :test
            $test_methodic_options.mandatories.count(:test).should eq 1
          end
        end
      end


      context "#known R/W" do
        it { $test_methodic_options.should respond_to("known") }
        it { $test_methodic_options.should respond_to("known=") }
        
        it "should be true that #known must return a List < Array" do
            $test_methodic_options.known.class.should eq(List)
        end
        it "#known.push affectation must be possible and #known must respond this affectation" do
          $test_methodic_options.known.push :test
          $test_methodic_options.known.should include :test
        end
        context "#known.push" do
          it "should not duplicate entry" do
            $test_methodic_options.known.push :test
            $test_methodic_options.known.push :test
            $test_methodic_options.known.count(:test).should eq 1
          end
        end
      end
    end
    context "Instance methods" do
      



      context "#options" do
        it { $test_methodic_options.should respond_to("options") }
        it "should be true that #options must return a Array" do
          $test_methodic_options.options.class.should eq(Array)
        end
        it "should respond an Array of options keys" do
          $test_methodic_options.options.each do |item|
            [:name,:surname].should include item
          end 
        end
      end
      
      context "#specify_default_value" do
        it { $test_methodic_options.should respond_to("specify_default_value") }
        it { $test_methodic_options.should respond_to("specify_defaults_values") }    
        it "should merge default value hash record in defaults attribut" do

          $test_methodic_options.specify_default_value :test => 'value'
          $test_methodic_options.defaults[:test].should eq 'value'
          $test_methodic_options.defaults.count.should eq 1
        end
        it "should redefine a new default value for a previous key" do 
          $test_methodic_options.specify_default_value :test => 'value'
          $test_methodic_options.defaults[:test].should eq 'value'
          $test_methodic_options.specify_default_value :test => 'newvalue'
          $test_methodic_options.defaults[:test].should eq 'newvalue'
        end
      end
      
      context "#specify_class_of" do 
        it { $test_methodic_options.should respond_to("specify_class_of") }
        it { $test_methodic_options.should respond_to("specify_classes_of") }
        it "should merge class hash record in classes attribut" do

          $test_methodic_options.specify_class_of :test => String
          $test_methodic_options.classes[:test].should eq String
          $test_methodic_options.classes.count.should eq 1
        end
        it "should redefine a new class value for a previous key" do
          $test_methodic_options.specify_class_of :test => String
          $test_methodic_options.classes[:test].should eq String
          $test_methodic_options.specify_class_of :test => Integer
          $test_methodic_options.classes[:test].should eq Integer

        end
      end





      context "#specify_condition_for" do
        it { $test_methodic_options.should respond_to("specify_condition_for") }
        it { $test_methodic_options.should respond_to("specify_conditions_for") }
        it "should merge condition hash record in conditions attribut" do
          aCond = Proc::new do |option| case option
                                         when "Doe" then true
                                         else false
                                       end
          end
          $test_methodic_options.specify_condition_for :name => aCond 
          $test_methodic_options.conditions[:name].should eq aCond
          $test_methodic_options.conditions.count.should eq 1
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
          $test_methodic_options.conditions[:name].should eq aCond
          $test_methodic_options.specify_condition_for :name => newCond 
          $test_methodic_options.conditions[:name].should eq newCond
          $test_methodic_options.conditions = {}
        end
      end

      context "#specify_format_of" do
        it { $test_methodic_options.should respond_to("specify_format_of") }
        it { $test_methodic_options.should respond_to("specify_formats_of") }
        it "should merge format hash record in formats attribut" do
          $test_methodic_options.formats = {}
          $test_methodic_options.specify_format_of :test => '.*'
          $test_methodic_options.formats[:test].should eq '.*'
          $test_methodic_options.formats.count.should eq 1
        end
        it "should redefine a new format value for a previous format key" do
          $test_methodic_options.specify_format_of :test => '.*'
          $test_methodic_options.formats[:test].should eq '.*'
          $test_methodic_options.specify_format_of :test => '\d*'
          $test_methodic_options.formats[:test].should eq '\d*' 
        end
      end

      context "#specify_presence_of" do
        it { $test_methodic_options.should respond_to("specify_presence_of") }
        it { $test_methodic_options.should respond_to("specify_presences_of") }
        it "should merge presence Array record in mandatories attribut" do
          $test_methodic_options.specify_presence_of :test
          $test_methodic_options.mandatories.should include(:test)
          $test_methodic_options.mandatories.count.should eq 1
          $test_methodic_options.specify_presence_of :test
          $test_methodic_options.mandatories.should include(:test)
          $test_methodic_options.mandatories.count.should eq 1
        end
        it "should be possible to give arguments list of symbols" do
          $test_methodic_options.specify_presences_of :test2, :test3, :test4
          $test_methodic_options.specify_presences_of [ :test5, :test6 ], :test7
        end
      end

      context "#specify_known_option" do
        it { $test_methodic_options.should respond_to("specify_known_option") }
        it { $test_methodic_options.should respond_to("specify_known_options") }
        it "should merge known Array record in known attribut" do
          $test_methodic_options.specify_known_option :test
          $test_methodic_options.known.should include(:test)
          $test_methodic_options.known.count.should eq 1
          $test_methodic_options.specify_known_option :test
          $test_methodic_options.known.should include(:test)
          $test_methodic_options.known.count.should eq 1
        end
        it "should be possible to give arguments list of symbols" do
          $test_methodic_options.specify_known_options :test2, :test3, :test4
          $test_methodic_options.specify_known_options [ :test5, :test6 ], :test7
          
        end
      end

      context "#validate" do
        
        it { $test_methodic_options.should respond_to("validate") }
        it { $test_methodic_options.should respond_to("validate!") }
        
        
        context "1/ validate known options" do
          context "@validate_known_options = false (default)" do            
            it "should not raise ArgumentError if mandatories is not fully include in the known options list" do
              $test_methodic_options.known = []
              $test_methodic_options.specify_presences_of [ :name, :surname]
              $test_methodic_options.specify_known_options [ :surname]
              lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
            end
            it "should not raise ArgumentError if an option in options list not in the known options list" do
              $test_methodic_options.known = []
              $test_methodic_options.specify_known_options [ :surname ]
              lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
            end
            it "should not raise if all given options in options list is in known options " do
              $test_methodic_options.known = []
              $test_methodic_options.specify_known_options [ :name, :surname, :optional ]
              lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
            end
            it "should not raise ArgumentError if formats made a reference to an unknown options" do
              $test_methodic_options.known = []
              $test_methodic_options.specify_format_of :nickname => /.*/
              $test_methodic_options.specify_known_options [ :surname, :name ]
              lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
            end
            it "should not raise ArgumentError if classes made a reference to an unknown options" do
              $test_methodic_options.known = []
              $test_methodic_options[:nickname] = 'Jeedoe'
              $test_methodic_options.specify_class_of :nickname => String
              $test_methodic_options.specify_known_options [ :surname, :name ]
              lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
            end
            it "should not raise ArgumentError if default made a reference to an unknown options" do
              $test_methodic_options.known = []
              $test_methodic_options.specify_default_value :nickname => 'Jeedoe'
              $test_methodic_options.specify_known_options [ :surname, :name ]
              lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
            end

          end
          context "@validate_known_options = true" do            
            it "should raise ArgumentError if mandatories is not fully include in the known options list" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_presences_of [ :name, :surname ]
              $test_methodic_options_with_known_options.specify_known_options [ :surname ]
              lambda{$test_methodic_options_with_known_options.validate!}.should raise_error ArgumentError
            end
            it "should raise ArgumentError if an option in options list not in the known options list" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_known_options [ :surname]
              lambda{$test_methodic_options_with_known_options.validate!}.should raise_error ArgumentError
            end
            it "should not raise if all given options in options list is in known options " do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_known_options [ :name, :surname,:optional]
              lambda{$test_methodic_options_with_known_options.validate!}.should_not raise_error ArgumentError
            end
            it "should raise ArgumentError if formats made a reference to an unknown options" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_format_of :nickname => /.*/
              $test_methodic_options_with_known_options.specify_known_options [ :surname, :name ]
              lambda{$test_methodic_options_with_known_options.validate!}.should raise_error ArgumentError
            end
            it "should raise ArgumentError if classes made a reference to an unknown options" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options[:nickname] = 'Jeedoe'
              $test_methodic_options_with_known_options.specify_class_of :nickname => String
              $test_methodic_options_with_known_options.specify_known_options [ :surname, :name ]
              lambda{$test_methodic_options_with_known_options.validate!}.should raise_error ArgumentError
            end
            it "should raise ArgumentError if default made a reference to an unknown options" do
              $test_methodic_options_with_known_options.known = []
              $test_methodic_options_with_known_options.specify_default_value :nickname => 'Jeedoe'
              $test_methodic_options_with_known_options.specify_known_options [ :surname, :name ]
              lambda{$test_methodic_options_with_known_options.validate!}.should raise_error ArgumentError
            end
            
          end
          
        end

        context "2/ validate classes" do
          it "should raise ArgumentError if an options don't match a class definition" do 
            $test_methodic_options.specify_classes_of :name => Integer, :surname => String
            lambda{$test_methodic_options.validate!}.should raise_error ArgumentError 

          end
          it "should not raise if options match class definition" do 
            $test_methodic_options.specify_classes_of :name => String, :surname => String
            lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError 
          end
        end
        context "3/ validate mandatories" do
          it "should raise ArgumentError if a mandatory option not in options list" do
            $test_methodic_options.specify_presences_of [ :name , :surname, :nickname, :age ]
            lambda{$test_methodic_options.validate!}.should raise_error ArgumentError

          end
          it "should not raise if mandatory options and options list match" do
            $test_methodic_options.specify_presences_of [ :name , :surname ]
            lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
          end
        end
        context "4/ validate formats" do
          it "should raise ArgumentError if an option in options list not have the good registered formats" do
            $test_methodic_options.specify_formats_of :name => /.*/, :surname => /toto.*/
            lambda{$test_methodic_options.validate!}.should raise_error ArgumentError

          end
          it "should not raise if all options in options list match formats definitions " do
            $test_methodic_options.specify_formats_of :name => /.*/, :surname => /.*/
            lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
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
            lambda{$test_methodic_options.validate!}.should raise_error ArgumentError

          end
          it "should not raise if all options in options list match formats definitions " do
           $test_methodic_options.conditions = {}
            aCond = Proc::new do |option| case option
                                          when 'Doe' then true
                                          else false
                                          end
            end
            $test_methodic_options.specify_condition_for :name => aCond
            lambda{$test_methodic_options.validate!}.should_not raise_error ArgumentError
          end
        end



      end 
      context "#merge_with_defaults" do
        it { $test_methodic_options.should respond_to("merge_with_defaults") }
        it { $test_methodic_options.should respond_to("merge") }
        it "should merge defaults values and don't override with options" do 
          $test_methodic_options.specify_defaults_values :name => 'Smith', :surname => 'Paul', :nickname => 'Jeedoe'
          $test_methodic_options.merge_with_defaults
          $test_methodic_options[:name].should eq "Doe"
          $test_methodic_options[:surname].should eq "John"
          $test_methodic_options[:nickname].should eq "Jeedoe"

        end
      end
    end
  end
  context "Methodic::get_options" do
    it "should return a Methodic::Options Object" do
      Methodic::get_options({:name => 'Doe', :surname => 'John'}).should be_an_instance_of Methodic::Options
    end
  end
  
end  
