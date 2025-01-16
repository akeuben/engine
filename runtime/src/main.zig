const std = @import("std");

const engine = @import("engine");

const zm = engine.zm;
const graphics = engine.graphics;
const log = engine.log;
const Window = engine.platform.Window;

const triangle_vertices: []const Vertex = &[_]Vertex{
    .{ .position = .{ -0.75, -0.75 }, .color = .{ 1.0, 0.0, 0.0 } },
    .{ .position = .{ -0.25, -0.75 }, .color = .{ 0.0, 1.0, 0.0 } },
    .{ .position = .{ -0.5, -0.25 }, .color = .{ 0.0, 0.0, 1.0 } },
};

const rectangle_vertices: []const Vertex = &[_]Vertex{
    .{ .position = .{ 0.25, 0.25 }, .color = .{ 0, 1, 1 } },
    .{ .position = .{ 0.25, 0.75 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ 0.75, 0.25 }, .color = .{ 0, 1, 1 } },
    .{ .position = .{ 0.75, 0.75 }, .color = .{ 1, 0, 0 } },
};

const renctangle_indices: []const u32 = &[_]u32{ 0, 1, 2, 2, 1, 3 };

const Vertex = packed struct {
    position: zm.Vec2f,
    color: zm.Vec3f,
};

pub fn main() !void {
    log.set_level(.DEBUG);

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    var context: graphics.Context = undefined;
    if (args.len != 2) {
        context = graphics.Context.init_none(std.heap.page_allocator);
    } else if (std.mem.eql(u8, "vk", args[1])) {
        context = graphics.Context.init_vulkan(std.heap.page_allocator);
    } else if (std.mem.eql(u8, "gl", args[1])) {
        context = graphics.Context.init_open_gl(std.heap.page_allocator);
    } else {
        context = graphics.Context.init_none(std.heap.page_allocator);
    }
    defer context.deinit();

    const window = Window.init(&context, std.heap.page_allocator);
    context.load(&window);

    const target = context.get_target();

    var triangle_buffer = try graphics.VertexBuffer.init(&context, Vertex, triangle_vertices);
    defer triangle_buffer.deinit();
    var rectangle_buffer = try graphics.VertexBuffer.init(&context, Vertex, rectangle_vertices);
    defer rectangle_buffer.deinit();
    var rectangle_index_buffer = graphics.IndexBuffer.init(&context, renctangle_indices);
    defer rectangle_index_buffer.deinit();

    const pipeline = try graphics.Pipeline.init_inline(&context, "basic", &triangle_buffer.get_layout(), &target);
    defer pipeline.deinit();

    var triangle = graphics.VertexRenderObject.init(&context, &pipeline, &triangle_buffer).object();
    const rectangle = graphics.IndexRenderObject.init(&context, &pipeline, &rectangle_buffer, &rectangle_index_buffer).object();

    while (!window.should_close()) {
        window.start_frame();

        target.start();
        triangle.draw(&target);
        rectangle.draw(&target);
        target.end();

        window.swap();
        window.update();
    }
}
