defmodule Password do

    @special [?!..?/, ?:..?@, ?[..?`, ?{..?~]
        |> Enum.map(fn r -> Enum.to_list(r) end)
        |> Enum.join
        |> String.to_charlist

    @lowercase ?a..?z
    @uppercase ?A..?Z
    @numbers ?0..?9

    @characters_sets [@lowercase, @uppercase, @numbers, @special]

    @characters @characters_sets
        |> Enum.map(&Enum.to_list/1)
        |> Enum.join
        |> String.to_charlist

    def generate(length) when is_integer(length) and length > 4 do
        required = @characters_sets
            |> Enum.map(&Enum.random/1)

        length_without_required = length - 4

        base = 1..length_without_required
            |> Enum.map(fn _ -> Enum.random(@characters) end)

        base ++ required
            |> Enum.shuffle
    end

    def generate(length) when is_integer(length) do
        raise "Length has to be greater than 4"
    end
    def generate(_), do: raise "The parameter should be an integer, greater than 4"

end

help = '''
Invalid argument.
Try

    --length value

where value is greater than 4.
'''

case OptionParser.parse(System.argv(), strict: [length: :integer]) do
    {[length: length], _, _} ->
        if length <= 4 do
            IO.puts help
        else
            IO.puts Password.generate(length)
        end
    _ -> IO.puts(:stderr, help)
end

