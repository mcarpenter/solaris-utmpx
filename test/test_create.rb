
require 'test/unit'
require 'solaris/utmpx'

class TestCreate < Test::Unit::TestCase #:nodoc:

  def test_create
    utmpx = Solaris::Utmpx.new(:endian => :big)
    record = utmpx.create(
      :ut_user => "root",
      :ut_id => "co10",
      :ut_line => "console",
      :ut_pid => 1407,
      :ut_type => 7,
      :ut_termination => 0,
      :ut_exit => 53726,
      :ut_tv_sec => 1297338834,
      :ut_tv_usec => 0,
      :ut_session => 0,
      :ut_syslen => 8,
      :ut_host => "jupiter"
    )
    assert_equal("root", record.ut_user)
    assert_equal("co10", record.ut_id)
    assert_equal("console", record.ut_line)
    assert_equal(1407, record.ut_pid)
    assert_equal(7, record.ut_type)
    assert_equal(0, record.ut_termination)
    assert_equal(53726, record.ut_exit)
    assert_equal(1297338834, record.ut_tv_sec)
    assert_equal(0, record.ut_tv_usec)
    assert_equal(0, record.ut_session)
    assert_equal(8, record.ut_syslen)
    assert_equal("jupiter", record.ut_host)
  end

  def test_create_invalid_fields
    utmpx = Solaris::Utmpx.new(:endian => :big)
    assert_raise(ArgumentError) do
      utmpx.create(:quack => :boom)
    end
  end

end # TestCreate

