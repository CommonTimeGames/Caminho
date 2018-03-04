# Caminho #

Caminho is a flexible, lightweight dialogue engine for games. 
Written in Lua, it embeds easily into your game engine of choice,
and allows you to focus on creating great content, not boilerplate code.

### Features ###

* Decouple dialogue content and logic from your game code.
* Iterate dialogue content without recompiling.
* Write dialogues with a simple syntax.
* Easily script complicated behaviors in your dialogues with Lua.
* Test and debug dialogues outside your game!

### Platforms ###

This is the Lua backend of Caminho. If you’re running a game engine such as Unity 
you’re probably more interested in one of the native bindings:

* Unity - Caminho-Unity
* .NET - Caminho.NET

Coming soon (hopefully)

* Java - Caminho.Java (coming soon!)
* C++ - Caminho++ (coming soon!)
* JS - Caminho.js (coming soon!)

However, you can still use these scripts to write
and test your own dialogue content. 

### Quickstart ###

First, you’ll need to install Lua if you haven’t already. 
This step is not necessary when using native bindings, above.

Next, let’s create a dialogue file:

#### hello.lua ####

    require('dialogue')

    local d = Dialogue:new()`

    d:sequence{
       start=true,
       name="test",
       {text="Hello, World!"},
       {text="Welcome to Caminho!"},
       {text="Have a nice day!"}
     }

    return d

Now let's run our dialogue:

    require(‘caminho’)

    c = Caminho:new()

    c:Start{name=“helloWorld”}
    print(c.current.text) --‘Hello, World!’

    c:continue()
    print(c.current.text) --‘Welcome to Caminho!’

    c:continue()
    print(c.current.text) --‘Have a nice day!’

You can also run it at the command line:

> lua run.lua hello.lua 

    [Text] Hello, World!
    Press ENTER to continue…

    [Text] Welcome to Caminho!
    Press ENTER to continue…

    [Text] Have a nice day!
    Press ENTER to continue…

For more information about how Caminho works, take a look at the [wiki](https://github.com/CommonTimeGames/Caminho/wiki).

### License ###

Caminho and its related projects are available under the MIT license.
