function scale = getTrajectoryScale(traj)

% Angles
qUpp = max(max(traj.grid.state(1:5,:)));
qLow = min(min(traj.grid.state(1:5,:)));

% Rates
dqUpp = max(max(traj.grid.state(6:10,:)));
dqLow = min(min(traj.grid.state(6:10,:)));

% Torques
uUpp = max(max(traj.grid.control));
uLow = min(min(traj.grid.control));

% Pack up
scale.angle = qUpp-qLow;
scale.rate = dqUpp-dqLow;
scale.control = uUpp-uLow;

end