using Godot;
using System;
using System.Collections.Generic;

public partial class RayCast3d : RayCast3D
{
	// how fast the raycast rotates
	[Export] public float rotation_speed = 90.0f; // degrees per second
	// direction of the raycast
	public int direction = 1; // 1 for increasing, -1 for decreasing

	// list for inserting the obstacles
	public List<int> items = new();

	// get the camera node
	private Node3D camera;
	private RayCast3D ray;

	// signals
	[Signal] public delegate void StopMovingEventHandler();
	[Signal] public delegate void StartMovingEventHandler();

	private int prev_angle = 0;
	private int i = 0;
	private int angles_to_send = 0;
	private int previous_angle = 0;

	private const int STEPS = 12;
	private const int START_DEGREE = 60;
	private const int END_DEGREE = 300;

	private List<int> angles_array = new();

	// set false for production
	public bool start_game = true;


	public override void _Ready()
	{
		i = 0;

		camera = GetParent<Node3D>();
		ray = this;

		ray.RotationDegrees = new Vector3(
			ray.RotationDegrees.X,
			START_DEGREE,
			ray.RotationDegrees.Z
		);

		prev_angle = START_DEGREE + STEPS;
		GD.Print(prev_angle);
	}


	public override void _Process(double delta)
	{
		if (!start_game)
			return;

		// wrap degrees between 0–360
		Vector3 rot = ray.RotationDegrees;
		rot.Y = Mathf.PosMod(rot.Y, 360);
		rot.Y -= rotation_speed * (float)delta;
		ray.RotationDegrees = rot;

		int current_angle = (int)RotationDegrees.Y;
		GD.Print(current_angle);
		// check angle bounds
		if (current_angle <= START_DEGREE || current_angle >= END_DEGREE)
		{
			// same formula as GDScript
			if (prev_angle + STEPS == current_angle)
			{
				if (IsColliding())
				{
					EmitSignal(SignalName.StopMoving);
					var collider = GetCollider() as Node;

					if (collider != null && collider.IsInGroup("box"))
					{
						items.Add(1);

						if (items.Count > 1)
						{
							Node3D parent = GetParent<Node3D>().GetParent<Node3D>();

							if (i < 10)
							{
								parent.RotationDegrees += new Vector3(0, 6, 0);
								angles_to_send = (int)(RotationDegrees.Y + 6);
							}
							else
							{
								parent.RotationDegrees -= new Vector3(0, 6, 0);
								angles_to_send = (int)(RotationDegrees.Y - 6);
							}
						}
					}
				}
				else
				{
					items.Add(0);
					EmitSignal(SignalName.StartMoving);
				}

				
				i++;

				prev_angle = current_angle;
				

				switch (prev_angle)
				{
					case 360:
						prev_angle = -STEPS;
						break;
					case 60:
						prev_angle = START_DEGREE - STEPS;
						break;
				}

			
			}

			// reset
			if (i > STEPS - 1)
			{
				items.Clear();
				i = 0;
			}
		}
	}


	// send only angles that change (like GDScript)
	public object GetAngles()
	{
		if (previous_angle != angles_to_send)
		{
			previous_angle = angles_to_send;
			return angles_to_send;
		}
		return "e";
	}


	// for starting the game
	private void _on_node_3d_connected()
	{
		start_game = true;
	}
}
