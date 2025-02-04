const std = @import("std");
const DesktopWindow = @import("desktop/window.zig").DesktopWindow;
const log = @import("../utils/log.zig");
const Context = @import("../graphics/context.zig").Context;
const VulkanExtension = @import("../graphics/vulkan/extension.zig").VulkanExtension;
const vk = @import("vulkan");
const VulkanContext = @import("../graphics/vulkan/context.zig").VulkanContext;
const os = @import("platform").os;

const WindowError = error{UnsupportedPlatform};

var initialized = false;

/// A window that can be rendered to.
pub const Window = union(enum) {
    desktop: *DesktopWindow,

    /// Create a window with a given context.
    ///
    /// **Parameter** `context`: The context to create the window for.
    /// **Parameter** `allocator`: The allocator used to create the window.
    pub fn init(context: *Context, allocator: std.mem.Allocator) Window {
        if (!initialized) {
            switch (comptime os) {
                .linux => DesktopWindow.init(),
                .windows => DesktopWindow.init(),
                else => {
                    log.fatal("Attempted to initialize window system on unsupported platform {s}", .{@tagName(os)});
                    std.process.exit(1);
                },
            }
            initialized = true;
        }
        return switch (comptime os) {
            .linux => .{ .desktop = DesktopWindow.create_window(context, allocator) },
            .windows => .{ .desktop = DesktopWindow.create_window(context, allocator) },
            else => {
                log.fatal("Attempted to create a window on an unsupported platform {s}", .{@tagName(os)});
                std.process.exit(1);
            },
        };
    }

    pub fn set_size_screenspace(self: Window, width: i32, height: i32) void {
        switch (self) {
            inline else => |case| case.set_width(width, height),
        }
    }

    pub fn get_size_pixels(self: Window) @Vector(2, i32) {
        return switch (self) {
            inline else => |case| case.get_size_pixels(),
        };
    }

    pub fn update(self: Window) void {
        switch (self) {
            inline else => |case| case.update(),
        }
    }

    pub fn set_current_context(self: Window, context: Context) void {
        switch (self) {
            inline else => |case| case.set_current_context(context),
        }
    }

    pub fn start_frame(self: Window) void {
        switch (self) {
            inline else => |case| case.start_frame(),
        }
    }

    pub fn swap(self: Window) void {
        switch (self) {
            inline else => |case| case.swap(),
        }
    }

    pub fn should_close(self: Window) bool {
        return switch (self) {
            inline else => |case| case.should_close(),
        };
    }

    pub fn get_gl_loader(self: Window, gl_extension: []const u8) ?*anyopaque {
        return switch (self) {
            inline else => |case| case.get_gl_loader(gl_extension),
        };
    }

    pub fn get_proc_addr_fn(self: Window) *const anyopaque {
        return switch (self) {
            inline else => |case| case.get_proc_addr_fn(),
        };
    }

    pub fn get_vk_exts(self: Window, allocator: std.mem.Allocator) []VulkanExtension {
        return switch (self) {
            inline else => |case| case.get_vk_exts(allocator),
        };
    }

    pub fn create_vk_surface(self: Window, ctx: *const VulkanContext) vk.SurfaceKHR {
        return switch (self) {
            inline else => |case| case.create_vk_surface(ctx),
        };
    }
};
