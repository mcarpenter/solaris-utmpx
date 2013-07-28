
require 'test/unit'
require 'solaris/utmpx'

class TestUtmpxSparc < Test::Unit::TestCase #:nodoc:

  def setup
    @reader = Solaris::Utmpx.new(:endian => :big)
    @io = File.open(File.join(File.dirname(__FILE__), 'wtmpx.sparc'), 'r')
    @records = []
    4.times { @records << @reader.read(@io) }
  end

  def teardown
    @io.close
  end

  def test_read
    assert_equal("root", @records[3].ut_user)
    assert_equal("co10", @records[3].ut_id)
    assert_equal("console", @records[3].ut_line)
    assert_equal(3944, @records[3].ut_pid)
    assert_equal(7, @records[3].ut_type)
    assert_equal(0, @records[3].ut_termination)
    assert_equal(0, @records[3].ut_exit)
    assert_equal(1230681969, @records[3].ut_tv_sec)
    assert_equal(0, @records[3].ut_tv_usec)
    assert_equal(0, @records[3].ut_session)
    assert_equal(0, @records[3].ut_syslen)
    assert_equal("", @records[3].ut_host)
  end

  def test_record_length
    @records.each do |record|
      assert_equal(Solaris::Utmpx::RECORD_LENGTH, record.to_binary_s.length)
    end
  end

  def test_ut_syslen
    @records.each do |record|
      # +1 since ut_syslen includes terminating null but only when non-zero
      if record.ut_syslen == 0
        assert_equal(record.ut_syslen, record.ut_host.length, "#{record}")
      else
        assert_equal(record.ut_syslen, record.ut_host.length + 1, "#{record}")
      end
    end
  end

  def test_to_binary_s
    @io.rewind
    @records.each do |record|
      raw = @io.read(Solaris::Utmpx::RECORD_LENGTH)
      assert_equal(raw, record.to_binary_s)
    end
  end

end # TestUtmpxSparc

