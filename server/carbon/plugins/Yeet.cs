using UnityEngine;

namespace Carbon.Plugins;

[Info("Yeet", "Not Raul don't sue me", "1.0.0")]
public class Yeet : CarbonPlugin
{
	private void OnServerInitialized()
	{
		Application.Quit();
	}
}