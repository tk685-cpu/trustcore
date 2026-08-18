# 2026-08-11T11:17:44.480904
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../../../../trustcorevivado/design_1_wrapper.xsa",os = "standalone",cpu = "psu_cortexa53_0",domain_name = "standalone_psu_cortexa53_0",generate_dtb = False,advanced_options = advanced_options,architecture = "64-bit",compiler = "gcc")

platform = client.get_component(name="platform")
domain = platform.add_domain(cpu = "psu_cortexa53_0",os = "standalone",name = "crypto_test",display_name = "crypto_test",generate_dtb = False)

comp = client.create_app_component(name="crypto_test",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "crypto_test")

status = platform.build()

comp = client.get_component(name="crypto_test")
comp.build()

status = platform.build()

comp.build()

vitis.dispose()

