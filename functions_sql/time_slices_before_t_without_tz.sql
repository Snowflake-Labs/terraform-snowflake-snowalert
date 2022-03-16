SELECT slice_start
     , slice_end
FROM TABLE(
  ${time_slices_function}(
    num_slices,
    DATEADD(sec, -seconds_in_slice * num_slices, t),
    t
  )
)
