{ assert, vows, connect, setup } = require("../helpers")


vows.describe("Connection insert").addBatch

  # -- connect().insert --

  "insert":
    topic: ->
      setup @callback

    "document only":
      topic: ->
        result = connect().insert("posts", title: "Insert 1.1")
        return result || "nothing"
      "should return null": (result)->
        assert.equal result, "nothing"
      "new document":
        topic: ->
          connect().find("posts", title: "Insert 1.1").one @callback
        "should exist in database": (object)->
          assert object

    "document and options":
      topic: ->
        result = connect().insert("posts", { title: "Insert 1.2" }, { safe: true })
        return result || "nothing"
      "should return null": (result)->
        assert.equal result, "nothing"
      "new document":
        topic: ->
          connect().find("posts", title: "Insert 1.2").one @callback
        "should exist in database": (object)->
          assert object

    "document, options and callback":
      topic: ->
        connect().insert "posts", { title: "Insert 1.3" }, { safe: true }, @callback
      "should pass document to callback": (post)->
        assert post
        assert.equal post.title, "Insert 1.3"
      "should set document ID": (post)->
        assert post._id
      "new document":
        topic: (post)->
          connect().find "posts", post._id, @callback
        "should exist in database": (post)->
          assert post
          assert.equal post.title, "Insert 1.3"

    "document and callback":
      topic: ->
        connect().insert "posts", title: "Insert 1.4", @callback
      "should pass document to callback": (post)->
        assert post
        assert.equal post.title, "Insert 1.4"
      "should set document ID": (post)->
        assert post._id
      "new document":
        topic: (post)->
          connect().find "posts", post._id, @callback
        "should exist in database": (post)->
          assert post
          assert.equal post.title, "Insert 1.4"

    "multiple documents, no callback":
      topic: ->
        result = connect().insert("posts", [{ title: "Insert 1.5", category: "foo" }, { title: "Insert 1.5", category: "bar" }])
        return result || "nothing"
      "should return null": (result)->
        assert.equal result, "nothing"
      "new documents":
        topic: ->
          connect().find("posts", title: "Insert 1.5").all @callback
        "should all exist in database": (posts)->
          assert.lengthOf posts, 2
          categories = (post.category for post in posts)
          assert.deepEqual categories, ["foo", "bar"]

    "multiple documents and callback":
      topic: ->
        connect().insert "posts", [{ title: "Insert 1.6", category: "foo" }, { title: "Insert 1.6", category: "bar" }], @callback
      "should pass all document to callback": (posts)->
        assert.lengthOf posts, 2
        for post in posts
          assert.equal post.title, "Insert 1.6"
      "should set document ID": (posts)->
        for post in posts
          assert post._id
      "new documents":
        topic: (posts)->
          ids = (post._id for post in posts)
          connect().find "posts", ids, @callback
        "should exist in database": (posts)->
          assert.lengthOf posts, 2
          categories = (post.category for post in posts)
          assert.deepEqual categories, ["foo", "bar"]

.export(module)
