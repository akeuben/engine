const std = @import("std");
const opengl = @import("opengl/context.zig");
const vulkan = @import("vulkan/context.zig");
const none = @import("none/context.zig");
const Window = @import("../platform/window.zig").Window;
const Pipeline = @import("shader.zig").Pipeline;
const VertexBuffer = @import("buffer.zig").VertexBuffer;
const RenderTarget = @import("target.zig").RenderTarget;

pub const API = enum { OPEN_GL, VULKAN, NONE };

pub const Context = union(API) {
    OPEN_GL: *opengl.OpenGLContext,
    VULKAN: *vulkan.VulkanContext,
    NONE: *none.NoneContext,

    pub fn init_open_gl(allocator: std.mem.Allocator) Context {
        return Context{
            .OPEN_GL = opengl.OpenGLContext.init(allocator),
        };
    }

    pub fn init_vulkan(allocator: std.mem.Allocator) Context {
        return Context{
            .VULKAN = vulkan.VulkanContext.init(allocator),
        };
    }

    pub fn init_none(allocator: std.mem.Allocator) Context {
        return Context{
            .NONE = none.NoneContext.init(allocator),
        };
    }

    pub fn deinit(self: *Context) void {
        switch (self.*) {
            inline else => |case| case.deinit(),
        }
    }

    pub fn load(self: *Context, window: *const Window) void {
        switch (self.*) {
            .OPEN_GL => opengl.OpenGLContext.load(self.OPEN_GL, window),
            .VULKAN => vulkan.VulkanContext.load(self.VULKAN, window),
            .NONE => none.NoneContext.load(self.NONE, window),
        }
    }

    pub fn get_target(self: *Context) RenderTarget {
        return switch (self.*) {
            .OPEN_GL => RenderTarget{
                .OPEN_GL = self.OPEN_GL.get_target(),
            },
            .VULKAN => RenderTarget{
                .VULKAN = self.VULKAN.get_target(),
            },
            .NONE => RenderTarget{
                .NONE = self.NONE.get_target(),
            },
        };
    }

    pub fn notify_resized(self: *Context, new_size: @Vector(2, i32)) void {
        switch (self.*) {
            .OPEN_GL => opengl.OpenGLContext.notify_resized(self.OPEN_GL, new_size),
            .VULKAN => vulkan.VulkanContext.notify_resized(self.VULKAN),
            .NONE => none.NoneContext.notify_resized(self.NONE),
        }
    }

    pub fn clear(self: Context) void {
        switch (self) {
            inline else => |case| case.clear(),
        }
    }
};
