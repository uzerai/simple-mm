import HomePage from './pages/Home';
import PlayerTable from "./components/PlayerTable";

export default [
  { path: "", component: HomePage },
  { path: "/players", component: PlayerTable },
];
