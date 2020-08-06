module Dealing
  class DealingProcess
    def initialize(store: Rails.configuration.event_store, bus: Rails.configuration.command_bus)
      @store = store
      @bus = bus
    end

    def call(event)
      closed_deal_id = event.data[:deal_id]
      closed_deal = Query::Deal.find_by!(uid: closed_deal_id)
      closed_adoption_request = closed_deal.adoption_request_id
      needs_to_be_closed = Query::Deal.where(adoption_request_id: closed_adoption_request, state: :negotiating)

      needs_to_be_closed.each do |d|
        # NOTE: If you pass an Int to a key that expects a String, the test fails with an untraceable error message.
        @bus.(Dealing::CancelDeal.new(deal_id: d.uid, reason: 'Deal closed'))
      end
    end
  end
end

# (druby://localhost:58437) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1690:in `perform_without_block': undefined method `__name__' for #<Minitest::Result:0x00007fec5b712290> (NoMethodError)
# 	from (druby://localhost:58437) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1646:in `perform'
# from (druby://localhost:58437) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1734:in `block (2 levels) in main_loop'
# 	from (druby://localhost:58437) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1730:in `loop'
# 	from (druby://localhost:58437) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1730:in `block in main_loop'
# from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/Library/Application Support/JetBrains/Toolbox/apps/RubyMine/ch-0/202.6397.95/RubyMine.app/Contents/plugins/ruby/rb/testing/patch/testunit/minitest/rm_reporter_plugin.rb:220:in `get_test_name'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/Library/Application Support/JetBrains/Toolbox/apps/RubyMine/ch-0/202.6397.95/RubyMine.app/Contents/plugins/ruby/rb/testing/patch/testunit/minitest/rm_reporter_plugin.rb:225:in `get_fqn_from_test'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/Library/Application Support/JetBrains/Toolbox/apps/RubyMine/ch-0/202.6397.95/RubyMine.app/Contents/plugins/ruby/rb/testing/patch/testunit/minitest/rm_reporter_plugin.rb:186:in `process_test_result'
# from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/Library/Application Support/JetBrains/Toolbox/apps/RubyMine/ch-0/202.6397.95/RubyMine.app/Contents/plugins/ruby/rb/testing/patch/testunit/minitest/rm_reporter_plugin.rb:178:in `record'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/minitest-5.14.1/lib/minitest.rb:861:in `block in record'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/minitest-5.14.1/lib/minitest.rb:860:in `each'
# from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/minitest-5.14.1/lib/minitest.rb:860:in `record'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:21:in `block in record'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/mutex_m.rb:78:in `synchronize'
# from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/mutex_m.rb:78:in `mu_synchronize'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:20:in `record'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1690:in `perform_without_block'
# from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1646:in `perform'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1734:in `block (2 levels) in main_loop'
# 	from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1730:in `loop'
# from (drbunix:/var/folders/g8/2z5tp3c11cx22bb128rgb3z80000gp/T/druby88496.0) /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/2.7.0/drb/drb.rb:1730:in `block in main_loop'
# 	from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:95:in `block (2 levels) in start'
# 	from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:75:in `fork'
# from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:75:in `block in start'
# 	from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:74:in `times'
# 	from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:74:in `each'
# from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:74:in `map'
# 	from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:74:in `start'
# 	from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/minitest-5.14.1/lib/minitest.rb:138:in `run'
# from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/minitest-5.14.1/lib/minitest.rb:68:in `block in autorun'
# /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/activesupport-6.0.3.2/lib/active_support/testing/parallelization.rb:124:in `shutdown': Queue not empty, but all workers have finished. This probably means that a worker crashed and 1 tests were missed. (RuntimeError)
# 	from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/minitest-5.14.1/lib/minitest.rb:145:in `run'
# from /Users/SatoshiKorin/.asdf/installs/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/minitest-5.14.1/lib/minitest.rb:68:in `block in autorun'
#
# Process finished with exit code 1
