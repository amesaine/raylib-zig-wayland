# raylib-zig-wayland

Setup C interop with raylib on Wayland for dummies (aka me).

## Environment

- Zig 0.13.0
- raylib commit [efce4d6](https://github.com/raysan5/raylib/tree/efce4d69ce913bca42289184b0bffe4339c0193f) July 25, 2024
- Debian 12
- SwayWM

## Install System Libraries

You need to install dev libraries such as for X11/Wayland via your distro's package manager.
We're on Debian so we'll follow the [Ubuntu section](https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux#ubuntu) of the raylib wiki.

```
sudo apt install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev libwayland-dev libxkbcommon-dev
```

This is because in raylib's own build file `src/build.zig`, you'll see it link system libraries.

```zig
fn compileRaylib(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, options: Options) !*std.Build.Step.Compile {
    // ...
    switch (target.result.os.tag) {
        // ...
        .linux => {
            // ...
                if (options.linux_display_backend == .Wayland or options.linux_display_backend == .Both) {
                    raylib.defineCMacro("_GLFW_WAYLAND", null);
                    raylib.linkSystemLibrary("wayland-client");
                    raylib.linkSystemLibrary("wayland-cursor");
                    raylib.linkSystemLibrary("wayland-egl");
                    raylib.linkSystemLibrary("xkbcommon");
                    raylib.addIncludePath(b.path("src"));
                    waylandGenerate(b, raylib, "wayland.xml", "wayland-client-protocol");
                    waylandGenerate(b, raylib, "xdg-shell.xml", "xdg-shell-client-protocol");
                    waylandGenerate(b, raylib, "xdg-decoration-unstable-v1.xml", "xdg-decoration-unstable-v1-client-protocol");
                    waylandGenerate(b, raylib, "viewporter.xml", "viewporter-client-protocol");
                    waylandGenerate(b, raylib, "relative-pointer-unstable-v1.xml", "relative-pointer-unstable-v1-client-protocol");
                    waylandGenerate(b, raylib, "pointer-constraints-unstable-v1.xml", "pointer-constraints-unstable-v1-client-protocol");
                    waylandGenerate(b, raylib, "fractional-scale-v1.xml", "fractional-scale-v1-client-protocol");
                    waylandGenerate(b, raylib, "xdg-activation-v1.xml", "xdg-activation-v1-client-protocol");
                    waylandGenerate(b, raylib, "idle-inhibit-unstable-v1.xml", "idle-inhibit-unstable-v1-client-protocol");
                }
                raylib.defineCMacro("PLATFORM_DESKTOP", null);
            // ...
}
```

## Linking raylib

There's two ways to do this. Either add the raylib repo as a git submodule or `zig fetch --save`
a raylib tarball. Let's use zig fetch.

### Zig Fetch

#### Source Code Archive URL

Since the release of raylib 5.0 back in November 2023, there's been breaking changes
in [Zig's build system](https://ziggit.dev/t/error-linking-raylib-via-raylib-zig/3384) 
and updates to raylib's [wayland compatibility](https://ziggit.dev/t/help-with-building-raylib/3589/19).
The latest raylib commit addresses these changes so let's use it.

```
zig fetch --save=raylib zig fetch --save=raylib https://github.com/raysan5/raylib/archive/efce4d69ce913bca42289184b0bffe4339c0193f.tar.gz 
```

This is a **source code archive URL**. It's a tarball of a specific commit. You
won't find this URL via the GitHub user interface. It is something you'll have to type in.
Refer to the [GitHub docs.](https://docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives#source-code-archive-urls)

The alternative here is to fetch `Source Code (tar.gz)` of a specific [release.](https://github.com/raysan5/raylib/releases)

Zig fetch then automatically sets up `build.zig.zon` for you.

#### build.zig and main.zig

As for setting up `build.zig` and importing raylib in `yourfile.zig`, I don't know too lol.
I just copied this minimal [zig raylib repo.](https://github.com/SimonLSchlee/zigraylib.)
Don't let nescience stop you from progressing.


### Git Submodule

#### Cloning

We could also keep a local copy of the raylib repo and manually link the library.
In the project root directory:

```sh
mkdir lib
cd lib
git submodule add https://github.com/raysan5/raylib.git
```

Refer to this [youtube video from Codotaku](https://www.youtube.com/watch?v=DMURJbpo94g)

#### build.zig.zon

```zig
// ...
.dependencies = .{
    .raylib = .{
        .path = "lib/raylib"
    },
},
// ...
```
