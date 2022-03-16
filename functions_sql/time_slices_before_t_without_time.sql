SELECT
    slice_start,
    slice_end
FROM TABLE(
    ${data_time_slices_without_tz_function}(
        num_slices,
        DATEADD(
            sec,
            -seconds_in_slice * num_slices,
            CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP)::TIMESTAMP
        ),
        CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP)::TIMESTAMP
    )
)
