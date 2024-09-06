import { FC } from "hono/jsx";

const Leagues: FC = () => {
  return (
    <div hx-get="/api/v1/leagues" hx-trigger="load">
      <span className="loading loading-ring loading-lg htmx-indicator"></span>
    </div>
  );
};

export default Leagues;
