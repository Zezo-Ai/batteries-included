defmodule ControlServerWeb.Storybook.H1 do
  use PhoenixStorybook.Story, :component

  def function, do: &CommonUI.Typogoraphy.h1/1

  def attributes, do: []
  def slots, do: []

  def variations,
    do: [
      %Variation{
        id: :default,
        slots: ["H1 Header"]
      },
      %Variation{
        id: :with_sub,
        slots: [
          ~s|Main Text|,
          ~s|<:sub_header>Sub Header</:sub_header>|
        ]
      }
    ]
end
