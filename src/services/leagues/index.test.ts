import test, { describe, it } from "node:test";
import app from "../../index";
import assert from "node:assert";

describe("leagues controller", () => {
  it("200 status code: return drop down with all available leagues, if any ", async () => {
    const res = await app.request("api/v1/leagues");

    assert.strictEqual(200, res.status);
  });
});

test("Error handling for leagues", {
  todo: "need htmx views for error handling",
});
