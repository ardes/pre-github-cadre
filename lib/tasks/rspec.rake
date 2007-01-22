require 'spec/rake/spectask'

namespace :spec do
  namespace :doc do
  desc "Print Specdoc for all app specs"
    Spec::Rake::SpecTask.new('doc') do |t|
      t.spec_files = FileList[
        'spec/models/**/*_spec.rb',
        'spec/controllers/**/*_spec.rb',
        'spec/helpers/**/*_spec.rb',
        'spec/views/**/*_spec.rb'
      ]
      t.spec_opts = ["--format", "specdoc"]
    end

    desc "Print Specdoc for all model specs"
    Spec::Rake::SpecTask.new('models') do |t|
      t.spec_files = FileList[
        'spec/models/**/*_spec.rb'
      ]
      t.spec_opts = ["--format", "specdoc"]
    end
  end
end
