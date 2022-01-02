import Home from "./pages/Home"
import PlayerTable from "./components/PlayerTable"
import Login from "./pages/Login"

// Any route which has a displayName will be displayed in the main navigation menu header.
export default [
  { path: "/", component: Home, displayName: "Home" },
  { path: "/players", component: PlayerTable, displayName: "Players" },
  { path: "/games", component: null, displayName: "Games" },
  { path: "/login", component: Login }
];
