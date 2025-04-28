import arcpy
arcpy.ImportToolbox(r"@\Analysis Tools.tbx")
arcpy.analysis.Intersect(
    in_features="suitable_habitat #;selected_range #",
    out_feature_class=r"C:\Users\Gronefeld\Desktop\Compare_KBA_Criteria\iii_extend_of_suitable_habitat\selected_suitable_habitat.shp",
    join_attributes="ALL",
    cluster_tolerance=None,
    output_type="INPUT"
)
