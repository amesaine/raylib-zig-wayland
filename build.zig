const std = @import("std");
const raylib = @import("raylib");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "smear",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibrary(raylib_dep.artifact("raylib"));

    exe.linkLibC();
    _ = try raylib.addRaylib(b, target, optimize, .{ .linux_display_backend = .Wayland });

    b.installArtifact(exe);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
