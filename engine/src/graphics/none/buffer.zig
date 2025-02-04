const types = @import("../type.zig");

pub const NoneVertexBuffer = struct {
    pub fn init() NoneVertexBuffer {
        return .{};
    }

    pub fn bind(_: NoneVertexBuffer) void {}

    pub fn set_data(_: NoneVertexBuffer, comptime T: anytype, _: []const T) void {}

    pub fn unbind(_: NoneVertexBuffer) void {}

    pub fn get_layout(_: NoneVertexBuffer) types.BufferLayout {
        return undefined;
    }

    pub fn deinit(_: NoneVertexBuffer) void {}
};

pub const NoneIndexBuffer = struct {
    pub fn init() NoneIndexBuffer {
        return .{};
    }

    pub fn bind(_: NoneIndexBuffer) void {}

    pub fn set_data(_: NoneIndexBuffer, comptime T: anytype, _: []const T) void {}

    pub fn unbind(_: NoneIndexBuffer) void {}

    pub fn get_layout(_: NoneIndexBuffer) types.BufferLayout {
        return undefined;
    }

    pub fn deinit(_: NoneIndexBuffer) void {}
};
