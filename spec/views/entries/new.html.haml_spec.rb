require 'spec_helper'

describe "entries/new" do

  context "English locale" do

    before do
      I18n.locale = 'en'
    end

    describe "new entry form with no error msgs" do

      context "bilingual glossary" do

        before do
          @entry = stub_model(Entry).as_new_record
          assign(:base_languages, %w[en ja])
          Yogoshu::Locales.set_base_languages(:en, :ja)
        end

        it "renders form" do
          render
          rendered.should have_selector("form#new_entry")
        end

        it "renders input fields" do
          render
          rendered.should have_selector("input[type='text'][name='entry[term_in_en]']")
          rendered.should have_selector("input[type='text'][name='entry[term_in_ja]']")
          rendered.should have_selector("textarea[name='entry[info]']")
          rendered.should have_selector("textarea[name='entry[note]']")
          rendered.should have_selector("button[type='submit']")
        end

        context "trilingual glossary" do

          before do
            @entry = stub_model(Entry).as_new_record
            assign(:base_languages, %w[en ja de])
            Yogoshu::Locales.set_base_languages(:en, :ja, :de)
          end

          it "renders input fields" do
            render
            rendered.should have_selector("input[type='text'][name='entry[term_in_en]']")
            rendered.should have_selector("input[type='text'][name='entry[term_in_ja]']")
            rendered.should have_selector("input[type='text'][name='entry[term_in_de]']")
          end

        end

      end

    end

  end

end
