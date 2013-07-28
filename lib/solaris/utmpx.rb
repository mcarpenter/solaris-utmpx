
require 'bindata'

module Solaris

  # See "struct futmpx" in /usr/include/utmpx.h:
  #
  #     struct futmpx {
  #         char    ut_user[32];        /* user login name */
  #         char    ut_id[4];       /* inittab id */
  #         char    ut_line[32];        /* device name (console, lnxx) */
  #         pid32_t ut_pid;         /* process id */
  #         int16_t ut_type;        /* type of entry */
  #         struct {
  #             int16_t e_termination;  /* process termination status */
  #             int16_t e_exit;     /* process exit status */
  #         } ut_exit;          /* exit status of a process */
  #         struct timeval32 ut_tv;     /* time entry was made */
  #         int32_t ut_session;     /* session ID, user for windowing */
  #         int32_t pad[5];         /* reserved for future use */
  #         int16_t ut_syslen;      /* significant length of ut_host */
  #         char    ut_host[257];       /* remote host name */
  #     };
  #
  class Utmpx < BinData::Record

    # The (anonymous) class of generated records.
    attr_reader :record_class

    # Length of a raw utmpx record in bytes.
    RECORD_LENGTH = 372

    # Create a new Utmpx factory object. Options are:
    # * :endian -- mandatory, set to :big (SPARC) or :little (i386)
    # * :trim_padding -- trim terminating nulls from read strings
    # This will generate objects that are subclasses of BinData::Record.
    def initialize(opts)

      endianism = nil
      trim_padding = true
      opts.each do |key, value|
        case key
        when :endian
          endianism = value
        when :trim_padding
          trim_padding = value
        else
          raise ArgumentError, "Unknown option #{key.inspect}"
        end
      end

      @record_class = Class.new(BinData::Record) do

        endian endianism

        string :ut_user, :length => 32, :trim_padding => trim_padding
        string :ut_id, :length => 4, :trim_padding => trim_padding
        string :ut_line, :length => 32, :trim_padding => trim_padding
        uint32 :ut_pid
        uint16 :ut_type
        string :pad_word1, :length => 2 # align to 4 byte words
        uint16 :ut_termination
        uint16 :ut_exit
        uint32 :ut_tv_sec
        uint32 :ut_tv_usec
        uint32 :ut_session
        uint32 :pad0
        uint32 :pad1
        uint32 :pad2
        uint32 :pad3
        uint32 :pad4
        uint16 :ut_syslen
        string :ut_host, :length => 257, :trim_padding => trim_padding
        string :pad_word2, :length => 1 # align to 4 byte words

        # Return the timestamp of this record as a Time object in the local TZ.
        def localtime
          Time.at(self.ut_tv_sec + self.ut_tv_usec / 1_000_000.0)
        end

      end

    end

    # Create a new record. Interesting option keys are:
    # * :ut_user
    # * :ut_id
    # * :ut_line
    # * :ut_pid
    # * :ut_type
    # * :ut_termination
    # * :ut_exit
    # * :ut_tv_sec
    # * :ut_tv_usec
    # * :ut_session
    # * :ut_syslen
    # * :ut_host
    def create(opts={})
      # BinData silently discards unknown fields so we check.
      unknown_fields = opts.keys - self.record_class.fields.fields.map(&:name)
      raise ArgumentError, "Unknown fields #{unknown_fields.inspect}" unless unknown_fields.empty?
      @record_class.new(opts)
    end

    # Read a utmpx record from the given IO object.
    def read(io)
      @record_class.read(io)
    end

  end # Utmpx

end # Solaris

