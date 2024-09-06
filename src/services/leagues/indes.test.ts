import { describe, it } from "node:test";
import app from "../../index";
import assert from "node:assert";

describe("leagues controller", () => {
  it("Return drop down with all available leagues, if any ", async () => {
    const res = await app.request("api/v1/leagues");

    assert.strictEqual(200, res.status);
  });

  it(
    "500 error code",
    { todo: "need htmx views for error handling" },
    async () => {}
  );
});
