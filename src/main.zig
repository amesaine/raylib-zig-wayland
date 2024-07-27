const std = @import("std");

const rl = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    rl.InitWindow(800, 450, "Hey ZIG");
    defer rl.CloseWindow();

    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        rl.ClearBackground(rl.LIGHTGRAY);
        rl.DrawText("Hello zig! From amesaine", 280, 200, 20, rl.BLACK);
        rl.EndDrawing();
    }
}
