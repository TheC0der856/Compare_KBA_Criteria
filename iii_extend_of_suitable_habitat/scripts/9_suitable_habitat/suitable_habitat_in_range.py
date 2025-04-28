import arcpy
arcpy.ImportToolbox(r"@\Analysis Tools.tbx")
arcpy.analysis.Intersect(
    in_features="suitable_habitat #;range #",
    out_feature_class=r"C:\Users\Gronefeld\Desktop\Compare_KBA_Criteria\iii_extend_of_suitable_habitat\suitable_habitat_in_range.shp",
    join_attributes="ALL",
    cluster_tolerance=None,
    output_type="INPUT"
)
