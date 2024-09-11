import { FC } from "hono/jsx";

const Leagues: FC = () => {
  return (
    <div hx-ext="response-targets">
      <div
        hx-get="/api/v1/leagues"
        hx-trigger="load"
        hx-target-error="#leagues-error"
      >
        <span className="loading loading-ring loading-lg htmx-indicator"></span>
        <div id="leagues-error"></div>
      </div>
    </div>
  );
};

export default Leagues;
