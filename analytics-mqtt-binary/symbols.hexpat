#include <type/guid.pat>

using SymbolStream;

SymbolStream symbolStream @ 0x00;
//DataTypeEntry de1 @ 0x750;
//DataTypeEntry dataTypeExample @ 0x7c8;

using SymbolStreamHeader;
using SymbolStreamFlags;
using SymbolEntry;

using DataTypeEntry;
using DataTypeEntryHeader;

using AdsDataTypeId;
using AdsDataTypeFlags;

using CodePage;

struct SymbolStream {
    SymbolStreamHeader header;
    if (header.symbolCount > 0) {
        SymbolEntry symbols[header.symbolCount];
    }
    if (header.dataTypeCount > 0) {
        DataTypeEntry dataTypes[1]; // header.dataTypeCount
    }
};

struct SymbolStreamHeader {
    u8 majorVersion;
    u8 minorVersion;
    u16 headSize;
    u32 symbolCount;
    u32 symbolSize;
    u32 dataTypeCount;
    u32 dataTypeSize;
    u32 usedDynamicSymbols;
    CodePage codePage;
    SymbolStreamFlags flags;
    u32 reserved1 [[hidden]];
    u32 reserved2 [[hidden]];
    u32 reserved3 [[hidden]];
    u32 reserved4 [[hidden]];
    u128 hash [[comment("source code indicates this is stored as a GUID which is weird")]];
};

struct SymbolEntry {
    u32 entryLength;
    u32 indexGroup;
    u32 indexOffset;
    u32 size;
    AdsDataTypeId dataTypeId;
    AdsDataTypeFlags dataTypeFlags;
    u16 nameLength;
    u16 typeNameLength;
    u16 commentLength;
    char name[nameLength + 1];
    char typeName[typeNameLength + 1];
    char comment[commentLength + 1];
    type::GUID guid;
    padding[entryLength + addressof(this) - $];
};

struct AttributeEntry {
    u8 nameLength;
    u8 valueLength;
    char name[nameLength + 1];
    char value[valueLength + 1];
};

bitfield SymbolStreamFlags {
    bool onlineChange : 1;
    bool target64Bit : 1;
    bool baseTypesIncluded : 1;
    bool performQSort : 1;
    padding : 28;
};

struct DataTypeEntry {
    DataTypeEntryHeader header;
    char name[header.nameLength + 1];
    char type[header.typeNameLength + 1];
    char comment[header.commentLength + 1];
    type::GUID guid;
    u8 propertyCount;
    //Property properties[propertyCount];
    u8 _pad[header.entryLength
        - sizeof(header)
        - sizeof(name)
        - sizeof(type)
        - sizeof(comment)
        - sizeof(guid)
      //  - sizeof(propertyCount)
      //  - sizeof(properties)
    ];
};

struct DataTypeEntryHeader {
    u32 entryLength;
    u32 _pad00;
    u32 _pad01;
    u32 _pad02;
    u32 dataTypeSize;
    u32 _pad03;
    AdsDataTypeId dataTypeId;
    u32 _pad05;
    u16 nameLength;
    u16 typeNameLength;
    u16 commentLength;
    u32 _pad06;
};

enum AdsDataTypeId : u32 {
    VOID = 0,
    INT8 = 16,
    UINT8 = 17,
    INT16 = 2,
    UINT16 = 18,
    INT32 = 3,
    UINT32 = 19,
    INT64 = 20,
    UINT64 = 21,
    REAL32 = 4,
    REAL64 = 5,
    BIGTYPE= 65,
    STRING = 30,
    WSTRING = 31,
    REAL80 = 32,
    BIT = 33,
    MAXTYPES = 34,
};

bitfield AdsSymbolFlags {
    bool persistent : 1;
    bool bitValue : 1;
    bool referenceTo : 1;
    bool typeGuid : 1;
    bool tcComInterfacePointer : 1; // 0x0010
    bool readOnly : 1; // 0x0020
    bool interfaceMethodAccess : 1; // 0x0040
    bool methodDeref : 1; // 0x0080
    ContextMask : 4; // 0x0F00
    bool attributes : 1; // 0x1000
    bool static : 1; // 0x2000
    bool initOnReset : 1; // 0x4000
    bool extendedFlags : 1; // 0x8000
};

bitfield AdsDataTypeFlags {
    bool dataType : 1;
    bool dataItem : 1;
    bool referenceTo : 1;
    bool methodDeref : 1;
    bool oversample : 1; // 0x00000010
    bool bitValues : 1; // 0x00000020
    bool propItem : 1; // 0x00000040
    bool typeGuid : 1; // 0x00000080
    bool persistent : 1; // 0x00000100
    bool copyMask : 1; // 0x00000200
    bool tcComInterfacePointer : 1; // 0x00000400
    bool methodInfos : 1; // 0x00000800
    bool attributes : 1; // 0x00001000
    bool enumInfos : 1; // 0x00002000
    padding : 2;
    bool aligned : 1; // 0x00010000
    bool static : 1; // 0x00020000
    bool spLevels : 1; // 0x00040000
    bool ignorePersist : 1; // 0x00080000
    bool anySizeArray : 1; // 0x00100000
    bool persistantDatatype : 1; // 0x00200000
    bool initOnResult : 1; // 0x00400000
    padding : 9;
};

enum CodePage : u32 {
    UTF8 = 65001,
};