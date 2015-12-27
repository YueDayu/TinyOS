#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'OscilloscopeMsg'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 24

# The Active Message type associated with this message.
AM_TYPE = 147

class OscilloscopeMsg(tinyos.message.Message.Message):
    # Create a new OscilloscopeMsg of size 24.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=24):
        tinyos.message.Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
        self.amTypeSet(AM_TYPE)
    
    # Get AM_TYPE
    def get_amType(cls):
        return AM_TYPE
    
    get_amType = classmethod(get_amType)
    
    #
    # Return a String representation of this message. Includes the
    # message type name and the non-indexed field values.
    #
    def __str__(self):
        s = "Message <OscilloscopeMsg> \n"
        try:
            s += "  [version=0x%x]\n" % (self.get_version())
        except:
            pass
        try:
            s += "  [interval=0x%x]\n" % (self.get_interval())
        except:
            pass
        try:
            s += "  [id=0x%x]\n" % (self.get_id())
        except:
            pass
        try:
            s += "  [count=0x%x]\n" % (self.get_count())
        except:
            pass
        try:
            s += "  [timestamps=";
            for i in range(0, 2):
                s += "0x%x " % (self.getElement_timestamps(i) & 0xffff)
            s += "]\n";
        except:
            pass
        try:
            s += "  [temReadings=";
            for i in range(0, 2):
                s += "0x%x " % (self.getElement_temReadings(i) & 0xffff)
            s += "]\n";
        except:
            pass
        try:
            s += "  [humReadings=";
            for i in range(0, 2):
                s += "0x%x " % (self.getElement_humReadings(i) & 0xffff)
            s += "]\n";
        except:
            pass
        try:
            s += "  [parReadings=";
            for i in range(0, 2):
                s += "0x%x " % (self.getElement_parReadings(i) & 0xffff)
            s += "]\n";
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: version
    #   Field type: int
    #   Offset (bits): 0
    #   Size (bits): 16
    #

    #
    # Return whether the field 'version' is signed (False).
    #
    def isSigned_version(self):
        return False
    
    #
    # Return whether the field 'version' is an array (False).
    #
    def isArray_version(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'version'
    #
    def offset_version(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'version'
    #
    def offsetBits_version(self):
        return 0
    
    #
    # Return the value (as a int) of the field 'version'
    #
    def get_version(self):
        return self.getUIntElement(self.offsetBits_version(), 16, 1)
    
    #
    # Set the value of the field 'version'
    #
    def set_version(self, value):
        self.setUIntElement(self.offsetBits_version(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'version'
    #
    def size_version(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'version'
    #
    def sizeBits_version(self):
        return 16
    
    #
    # Accessor methods for field: interval
    #   Field type: int
    #   Offset (bits): 16
    #   Size (bits): 16
    #

    #
    # Return whether the field 'interval' is signed (False).
    #
    def isSigned_interval(self):
        return False
    
    #
    # Return whether the field 'interval' is an array (False).
    #
    def isArray_interval(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'interval'
    #
    def offset_interval(self):
        return (16 / 8)
    
    #
    # Return the offset (in bits) of the field 'interval'
    #
    def offsetBits_interval(self):
        return 16
    
    #
    # Return the value (as a int) of the field 'interval'
    #
    def get_interval(self):
        return self.getUIntElement(self.offsetBits_interval(), 16, 1)
    
    #
    # Set the value of the field 'interval'
    #
    def set_interval(self, value):
        self.setUIntElement(self.offsetBits_interval(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'interval'
    #
    def size_interval(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'interval'
    #
    def sizeBits_interval(self):
        return 16
    
    #
    # Accessor methods for field: id
    #   Field type: int
    #   Offset (bits): 32
    #   Size (bits): 16
    #

    #
    # Return whether the field 'id' is signed (False).
    #
    def isSigned_id(self):
        return False
    
    #
    # Return whether the field 'id' is an array (False).
    #
    def isArray_id(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'id'
    #
    def offset_id(self):
        return (32 / 8)
    
    #
    # Return the offset (in bits) of the field 'id'
    #
    def offsetBits_id(self):
        return 32
    
    #
    # Return the value (as a int) of the field 'id'
    #
    def get_id(self):
        return self.getUIntElement(self.offsetBits_id(), 16, 1)
    
    #
    # Set the value of the field 'id'
    #
    def set_id(self, value):
        self.setUIntElement(self.offsetBits_id(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'id'
    #
    def size_id(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'id'
    #
    def sizeBits_id(self):
        return 16
    
    #
    # Accessor methods for field: count
    #   Field type: int
    #   Offset (bits): 48
    #   Size (bits): 16
    #

    #
    # Return whether the field 'count' is signed (False).
    #
    def isSigned_count(self):
        return False
    
    #
    # Return whether the field 'count' is an array (False).
    #
    def isArray_count(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'count'
    #
    def offset_count(self):
        return (48 / 8)
    
    #
    # Return the offset (in bits) of the field 'count'
    #
    def offsetBits_count(self):
        return 48
    
    #
    # Return the value (as a int) of the field 'count'
    #
    def get_count(self):
        return self.getUIntElement(self.offsetBits_count(), 16, 1)
    
    #
    # Set the value of the field 'count'
    #
    def set_count(self, value):
        self.setUIntElement(self.offsetBits_count(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'count'
    #
    def size_count(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'count'
    #
    def sizeBits_count(self):
        return 16
    
    #
    # Accessor methods for field: timestamps
    #   Field type: int[]
    #   Offset (bits): 64
    #   Size of each element (bits): 16
    #

    #
    # Return whether the field 'timestamps' is signed (False).
    #
    def isSigned_timestamps(self):
        return False
    
    #
    # Return whether the field 'timestamps' is an array (True).
    #
    def isArray_timestamps(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'timestamps'
    #
    def offset_timestamps(self, index1):
        offset = 64
        if index1 < 0 or index1 >= 2:
            raise IndexError
        offset += 0 + index1 * 16
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'timestamps'
    #
    def offsetBits_timestamps(self, index1):
        offset = 64
        if index1 < 0 or index1 >= 2:
            raise IndexError
        offset += 0 + index1 * 16
        return offset
    
    #
    # Return the entire array 'timestamps' as a int[]
    #
    def get_timestamps(self):
        tmp = [None]*2
        for index0 in range (0, self.numElements_timestamps(0)):
                tmp[index0] = self.getElement_timestamps(index0)
        return tmp
    
    #
    # Set the contents of the array 'timestamps' from the given int[]
    #
    def set_timestamps(self, value):
        for index0 in range(0, len(value)):
            self.setElement_timestamps(index0, value[index0])

    #
    # Return an element (as a int) of the array 'timestamps'
    #
    def getElement_timestamps(self, index1):
        return self.getUIntElement(self.offsetBits_timestamps(index1), 16, 1)
    
    #
    # Set an element of the array 'timestamps'
    #
    def setElement_timestamps(self, index1, value):
        self.setUIntElement(self.offsetBits_timestamps(index1), 16, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'timestamps'
    #
    def totalSize_timestamps(self):
        return (32 / 8)
    
    #
    # Return the total size, in bits, of the array 'timestamps'
    #
    def totalSizeBits_timestamps(self):
        return 32
    
    #
    # Return the size, in bytes, of each element of the array 'timestamps'
    #
    def elementSize_timestamps(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'timestamps'
    #
    def elementSizeBits_timestamps(self):
        return 16
    
    #
    # Return the number of dimensions in the array 'timestamps'
    #
    def numDimensions_timestamps(self):
        return 1
    
    #
    # Return the number of elements in the array 'timestamps'
    #
    def numElements_timestamps():
        return 2
    
    #
    # Return the number of elements in the array 'timestamps'
    # for the given dimension.
    #
    def numElements_timestamps(self, dimension):
        array_dims = [ 2,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
    #
    # Accessor methods for field: temReadings
    #   Field type: int[]
    #   Offset (bits): 96
    #   Size of each element (bits): 16
    #

    #
    # Return whether the field 'temReadings' is signed (False).
    #
    def isSigned_temReadings(self):
        return False
    
    #
    # Return whether the field 'temReadings' is an array (True).
    #
    def isArray_temReadings(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'temReadings'
    #
    def offset_temReadings(self, index1):
        offset = 96
        if index1 < 0 or index1 >= 2:
            raise IndexError
        offset += 0 + index1 * 16
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'temReadings'
    #
    def offsetBits_temReadings(self, index1):
        offset = 96
        if index1 < 0 or index1 >= 2:
            raise IndexError
        offset += 0 + index1 * 16
        return offset
    
    #
    # Return the entire array 'temReadings' as a int[]
    #
    def get_temReadings(self):
        tmp = [None]*2
        for index0 in range (0, self.numElements_temReadings(0)):
                tmp[index0] = self.getElement_temReadings(index0)
        return tmp
    
    #
    # Set the contents of the array 'temReadings' from the given int[]
    #
    def set_temReadings(self, value):
        for index0 in range(0, len(value)):
            self.setElement_temReadings(index0, value[index0])

    #
    # Return an element (as a int) of the array 'temReadings'
    #
    def getElement_temReadings(self, index1):
        return self.getUIntElement(self.offsetBits_temReadings(index1), 16, 1)
    
    #
    # Set an element of the array 'temReadings'
    #
    def setElement_temReadings(self, index1, value):
        self.setUIntElement(self.offsetBits_temReadings(index1), 16, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'temReadings'
    #
    def totalSize_temReadings(self):
        return (32 / 8)
    
    #
    # Return the total size, in bits, of the array 'temReadings'
    #
    def totalSizeBits_temReadings(self):
        return 32
    
    #
    # Return the size, in bytes, of each element of the array 'temReadings'
    #
    def elementSize_temReadings(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'temReadings'
    #
    def elementSizeBits_temReadings(self):
        return 16
    
    #
    # Return the number of dimensions in the array 'temReadings'
    #
    def numDimensions_temReadings(self):
        return 1
    
    #
    # Return the number of elements in the array 'temReadings'
    #
    def numElements_temReadings():
        return 2
    
    #
    # Return the number of elements in the array 'temReadings'
    # for the given dimension.
    #
    def numElements_temReadings(self, dimension):
        array_dims = [ 2,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
    #
    # Accessor methods for field: humReadings
    #   Field type: int[]
    #   Offset (bits): 128
    #   Size of each element (bits): 16
    #

    #
    # Return whether the field 'humReadings' is signed (False).
    #
    def isSigned_humReadings(self):
        return False
    
    #
    # Return whether the field 'humReadings' is an array (True).
    #
    def isArray_humReadings(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'humReadings'
    #
    def offset_humReadings(self, index1):
        offset = 128
        if index1 < 0 or index1 >= 2:
            raise IndexError
        offset += 0 + index1 * 16
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'humReadings'
    #
    def offsetBits_humReadings(self, index1):
        offset = 128
        if index1 < 0 or index1 >= 2:
            raise IndexError
        offset += 0 + index1 * 16
        return offset
    
    #
    # Return the entire array 'humReadings' as a int[]
    #
    def get_humReadings(self):
        tmp = [None]*2
        for index0 in range (0, self.numElements_humReadings(0)):
                tmp[index0] = self.getElement_humReadings(index0)
        return tmp
    
    #
    # Set the contents of the array 'humReadings' from the given int[]
    #
    def set_humReadings(self, value):
        for index0 in range(0, len(value)):
            self.setElement_humReadings(index0, value[index0])

    #
    # Return an element (as a int) of the array 'humReadings'
    #
    def getElement_humReadings(self, index1):
        return self.getUIntElement(self.offsetBits_humReadings(index1), 16, 1)
    
    #
    # Set an element of the array 'humReadings'
    #
    def setElement_humReadings(self, index1, value):
        self.setUIntElement(self.offsetBits_humReadings(index1), 16, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'humReadings'
    #
    def totalSize_humReadings(self):
        return (32 / 8)
    
    #
    # Return the total size, in bits, of the array 'humReadings'
    #
    def totalSizeBits_humReadings(self):
        return 32
    
    #
    # Return the size, in bytes, of each element of the array 'humReadings'
    #
    def elementSize_humReadings(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'humReadings'
    #
    def elementSizeBits_humReadings(self):
        return 16
    
    #
    # Return the number of dimensions in the array 'humReadings'
    #
    def numDimensions_humReadings(self):
        return 1
    
    #
    # Return the number of elements in the array 'humReadings'
    #
    def numElements_humReadings():
        return 2
    
    #
    # Return the number of elements in the array 'humReadings'
    # for the given dimension.
    #
    def numElements_humReadings(self, dimension):
        array_dims = [ 2,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
    #
    # Accessor methods for field: parReadings
    #   Field type: int[]
    #   Offset (bits): 160
    #   Size of each element (bits): 16
    #

    #
    # Return whether the field 'parReadings' is signed (False).
    #
    def isSigned_parReadings(self):
        return False
    
    #
    # Return whether the field 'parReadings' is an array (True).
    #
    def isArray_parReadings(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'parReadings'
    #
    def offset_parReadings(self, index1):
        offset = 160
        if index1 < 0 or index1 >= 2:
            raise IndexError
        offset += 0 + index1 * 16
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'parReadings'
    #
    def offsetBits_parReadings(self, index1):
        offset = 160
        if index1 < 0 or index1 >= 2:
            raise IndexError
        offset += 0 + index1 * 16
        return offset
    
    #
    # Return the entire array 'parReadings' as a int[]
    #
    def get_parReadings(self):
        tmp = [None]*2
        for index0 in range (0, self.numElements_parReadings(0)):
                tmp[index0] = self.getElement_parReadings(index0)
        return tmp
    
    #
    # Set the contents of the array 'parReadings' from the given int[]
    #
    def set_parReadings(self, value):
        for index0 in range(0, len(value)):
            self.setElement_parReadings(index0, value[index0])

    #
    # Return an element (as a int) of the array 'parReadings'
    #
    def getElement_parReadings(self, index1):
        return self.getUIntElement(self.offsetBits_parReadings(index1), 16, 1)
    
    #
    # Set an element of the array 'parReadings'
    #
    def setElement_parReadings(self, index1, value):
        self.setUIntElement(self.offsetBits_parReadings(index1), 16, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'parReadings'
    #
    def totalSize_parReadings(self):
        return (32 / 8)
    
    #
    # Return the total size, in bits, of the array 'parReadings'
    #
    def totalSizeBits_parReadings(self):
        return 32
    
    #
    # Return the size, in bytes, of each element of the array 'parReadings'
    #
    def elementSize_parReadings(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'parReadings'
    #
    def elementSizeBits_parReadings(self):
        return 16
    
    #
    # Return the number of dimensions in the array 'parReadings'
    #
    def numDimensions_parReadings(self):
        return 1
    
    #
    # Return the number of elements in the array 'parReadings'
    #
    def numElements_parReadings():
        return 2
    
    #
    # Return the number of elements in the array 'parReadings'
    # for the given dimension.
    #
    def numElements_parReadings(self, dimension):
        array_dims = [ 2,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    