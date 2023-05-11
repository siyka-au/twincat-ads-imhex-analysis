#include <type/guid.pat>

using ProcessData;

ProcessData processData @ 0x00;

using ProcessDataHeader;

struct Sample<auto Size> {
    u64 timestamp [[comment("number of 100-nanoseconds elapsed since January 1, 1601 (UTC)")]];
    u8 data[Size];
};

struct ProcessData {
    ProcessDataHeader header;
    Sample<header.dataSize> sample[header.samples];
};

using AnalyticsStreamHeaderFlags;

struct ProcessDataHeader {
    u8 majorVersion;
    u8 minorVersion;
    u8 headerSize;
    u8 sampleHeaderSize;
    u32 dataSize;
    u32 cycleTime [[comment("units of 100ns intervals")]];
    AnalyticsStreamHeaderFlags completeFlags;
    type::GUID guid;
    if (majorVersion == 1 && minorVersion == 1) {
        u32 samples;
        padding[4];
        u64 streamStartTime [[comment("number of 100-nanoseconds elapsed since January 1, 1601 (UTC)")]];
        u64 streamStopTime [[comment("number of 100-nanoseconds elapsed since January 1, 1601 (UTC)")]];
    }
};

using CompressionMethod;

bitfield AnalyticsStreamHeaderFlags {
    headTimestamp : 1;
    sampleTimestamp : 1;
    dcTime : 1;
    reserved : 1;
    CompressionMethod compressionMethod : 3;
    padding : 25;
};

enum CompressionMethod : u8 {
    NONE = 0,
    RUN_LENGTH = 1,
    RESERVED = 2
};