import { describe, it } from "node:test";
import app from "../../index";
import assert from "node:assert";

describe("teams controller", async () => {
  it("200 Status Code: returns a view for teams, whether epmty or not.", async () => {
    const res = await app.request("/api/v1/teams", {
      method: "POST",
      body: new URLSearchParams({
        team_league_id: "21aa9188-2956-4947-81d3-bf855b53136c",
      }).toString(),
      headers: new Headers({
        "Content-Type": "application/x-www-form-urlencoded",
      }),
    });

    assert.strictEqual(200, res.status);
  });

  it("404 status code: returns a zod error object", async () => {
    const res = await app.request("/api/v1/teams");

    assert.strictEqual(404, res.status);
  });
});
